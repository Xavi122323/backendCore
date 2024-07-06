require 'rest-client'
require 'jwt'

class KeycloakService
  def self.get_token(username, password)
    response = RestClient::Request.execute(
      method: :post,
      url: "#{KEYCLOAK_CONFIG[:server_url]}/realms/#{KEYCLOAK_CONFIG[:realm]}/protocol/openid-connect/token",
      payload: {
        client_id: KEYCLOAK_CONFIG[:client_id],
        client_secret: KEYCLOAK_CONFIG[:client_secret],
        grant_type: 'password',
        username: username,
        password: password
      },
      headers: { accept: :json },
      verify_ssl: false
    )
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Keycloak authentication error: #{e.response}"
    nil
  end

  def self.decode_token(token)
    jwks_url = "#{KEYCLOAK_CONFIG[:server_url]}/realms/#{KEYCLOAK_CONFIG[:realm]}/protocol/openid-connect/certs"
    jwks_keys = JSON.parse(RestClient::Request.execute(method: :get, url: jwks_url, headers: { accept: :json }, verify_ssl: false).body)["keys"]
    
    jwk_loader = ->(options) { jwks_keys }
    options = { algorithms: ['RS256'], jwks: jwk_loader }
    
    JWT.decode(token, nil, true, options).first
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end
end
