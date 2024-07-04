class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable, :trackable, :lockable

  enum role: [:user, :admin, :dba], _default: :user

  def self.from_keycloak(id)
    user = find_or_create_by(keycloak_id: id)
    user
  end
end
