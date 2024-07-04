KEYCLOAK_CONFIG = {
  server_url: 'https://cloak.mindsoftdev.com:8443',
  realm: 'external',
  client_id: 'ruby-client',
  client_secret: Rails.application.credentials.keycloak_client_secret
}

