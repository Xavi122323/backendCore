class Api::V1::SessionsController < ApplicationController
  skip_before_action :process_token, only: [:create]

  def create
    response = keycloak_authenticate(sign_in_params[:email], sign_in_params[:password])
    
    if response[:status] == :success
      token = response[:body]['access_token']
      decoded_token = JWT.decode(token, nil, true, { algorithms: ['RS256'], jwks: response[:jwks] })[0]
      
      user = User.find_or_create_from_keycloak(decoded_token)
      
      render json: { token: token }, status: :ok
    else
      render json: { errors: response[:body] }, status: :unprocessable_entity
    end
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  def keycloak_authenticate(email, password)
    url = "https://cloak.mindsoftdev.com:8443/realms/external/protocol/openid-connect/token"
    client_id = 'external-clients'
    client_secret = 'tdW9rcKMUGdVONoq6ah12RmrbrDZbaLOM'

    response = HTTP.headers(accept: 'application/json')
                   .post(url, form: {
                     client_id: client_id,
                     grant_type: 'password',
                     username: email,
                     password: password,
                     client_secret: client_secret
                   }, ssl_context: OpenSSL::SSL::SSLContext.new.tap { |ctx| ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE })

    if response.status.success?
      jwks_url = "https://cloak.mindsoftdev.com:8443/realms/external/protocol/openid-connect/certs"
      jwks = HTTP.get(jwks_url, ssl_context: OpenSSL::SSL::SSLContext.new.tap { |ctx| ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE }).parse(:json)
      { status: :success, body: response.parse(:json), jwks: jwks }
    else
      { status: :failure, body: response.parse(:json) }
    end
  end
end
