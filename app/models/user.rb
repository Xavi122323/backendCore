class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :registerable, :trackable, :lockable

  enum role: [:user, :admin], _default: :user

  def generate_jwt
    JWT.encode({id: id, role: role, exp: 60.days.from_now.to_i}, Rails.application.secrets.secret_key_base)
  end
end
