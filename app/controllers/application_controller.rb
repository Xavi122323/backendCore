class ApplicationController < ActionController::API

  respond_to :json

  before_action :process_token

  private

  def process_token
      if request.headers['Authorization'].present?
        begin
          jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.secrets.secret_key_base).first
          @current_user_id = jwt_payload['id']
          @current_user_role = jwt_payload['role']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
  end

  def authenticate_user!(options = {})
      #head :unauthorized unless signed_in?
      head :unauthorized unless signed_in? && (options[:roles].nil? || options[:roles].include?(@current_user_role))
  end

  def signed_in?
      @current_user_id.present?
  end

  def current_user
      @current_user ||= super || User.find(@current_user_id)
  end

end
