class ApplicationController < ActionController::API
  respond_to :json 

  before_action :process_token

  private

  def process_token
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ')[1]
        jwks_url = "https://cloak.mindsoftdev.com:8443/realms/external/protocol/openid-connect/certs"
        jwks = HTTP.get(jwks_url).parse(:json)
        decoded_token = JWT.decode(token, nil, true, { algorithms: ['RS256'], jwks: jwks })[0]

        @current_user = User.find_or_create_from_keycloak(decoded_token)
      rescue JWT::ExpiredSignature
        head :unauthorized and return
      rescue JWT::VerificationError, JWT::DecodeError => e
        render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized and return
      end
    else
      head :unauthorized
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def signed_in?
    @current_user.present?
  end

  def current_user
    @current_user
  end
end
