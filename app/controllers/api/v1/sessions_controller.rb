class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    auth = request.env['omniauth.auth']
    user = User.from_keycloak(auth.info)
    if user
      token = user.generate_jwt
      render json: token.to_json
    else
      render json: { errors: 'Invalid login' }, status: :unauthorized
    end
  end
end
