Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keycloak_openid, 
           'external-clients', 
           'tdW9rcKMUGdVONoq6ah1ZRmrbDZbaL0M',
           client_options: {
             site: 'https://cloak.mindsoftdev.com:8443/auth',
             realm: 'external',
             authorize_url: '/realms/external/protocol/openid-connect/auth',
             token_url: '/realms/external/protocol/openid-connect/token',
             userinfo_url: '/realms/external/protocol/openid-connect/userinfo'
           }
end
