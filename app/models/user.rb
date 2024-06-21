class User < ApplicationRecord
  def self.from_keycloak(payload)
    find_or_create_by(email: payload['email']) do |user|
      user.name = payload['name']
      user.role = payload['role']
    end
  end
end
