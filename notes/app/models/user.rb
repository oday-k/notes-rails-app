class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :validatable,
         jwt_revocation_strategy: JwtDenylist

  def authenticate(password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  has_many :notes
end
