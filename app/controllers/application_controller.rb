class ApplicationController < ActionController::API

  respond_to :json

  before_action :process_token

  private

  def process_token
      if request.headers['Authorization'].present?
        begin
          jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1]).first
          @current_user_id = jwt_payload['id']
          @current_user_role = jwt_payload['role']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
  end

  def authenticate_user!(options = {})
      #head :unauthorized unless signed_in?
      head :unauthorized unless signed_in?
  end

  def signed_in?
      @current_user_id.present?
  end

  def authenticate_admin!(options = {})
      #head :unauthorized unless signed_in?
      head :unauthorized unless signed_in_admin?
  end

  def signed_in_admin?
      @current_user_id.present? && @current_user_role == "1"
  end

  def current_user
      @current_user ||= super || User.find(@current_user_id)
  end

end
