class ApplicationController < ActionController::API
  respond_to :json

  before_action :process_token

  private

  def process_token
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      jwt_payload = KeycloakService.decode_token(token)
      if jwt_payload
        @current_user_id = jwt_payload['sub']
      else
        head :unauthorized
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def signed_in?
    @current_user_id.present?
  end

  def current_user
    @current_user ||= User.find_by(keycloak_id: @current_user_id)
  end
end
