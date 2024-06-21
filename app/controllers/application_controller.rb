require 'net/http'
require 'uri'
require 'json'
require 'jwt'

class ApplicationController < ActionController::API
  respond_to :json

  before_action :authenticate_user!

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        options = { algorithm: 'RS256', iss: 'https://cloak.mindsoftdev.com:8443/auth/realms/external', verify_iss: true }
        payload, _header = JWT.decode(token, nil, true, options) do |header|
          jwks_hash[header['kid']]
        end
        @current_user = User.find_or_create_by(email: payload['email']) do |user|
          user.name = payload['name']
          user.role = payload['role']
        end
      rescue JWT::DecodeError => e
        render json: { error: e.message }, status: :unauthorized
      end
    else
      render json: { error: 'Missing token' }, status: :unauthorized
    end
  end

  def jwks_hash
    jwks_raw = Net::HTTP.get URI('https://cloak.mindsoftdev.com:8443/auth/realms/external/protocol/openid-connect/certs')
    jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
    Hash[
      jwks_keys
        .map do |k|
          [
            k['kid'],
            OpenSSL::X509::Certificate.new(Base64.decode64(k['x5c'].first)).public_key
          ]
        end
    ]
  end
end
