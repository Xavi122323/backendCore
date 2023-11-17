class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :registerable, :trackable, :lockable

  enum role: [:user, :admin], _default: :user

  def generate_jwt
    JWT.encode({id: id, role: role_before_type_cast, exp: 1.days.from_now.to_i})
  end
end
