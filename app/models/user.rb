class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable, :trackable, :lockable

  enum role: [:user, :admin, :dba], _default: :user

  def self.find_or_create_from_keycloak(decoded_token)
    find_or_create_by(id: decoded_token['sub']) do |user|
      user.email = decoded_token['email']
      user.role = :user  # Default role, as roles are not used in this setup
    end
  end
end
