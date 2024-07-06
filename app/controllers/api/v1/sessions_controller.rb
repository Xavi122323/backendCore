class Api::V1::SessionsController < ApplicationController
  def create
    username = sign_in_params[:email]
    password = sign_in_params[:password]
    
    token_data = KeycloakService.get_token(username, password)

    if token_data
      render json: token_data
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
