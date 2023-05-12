class User < ApplicationRecord
  include Authenticatable
  before_create :generate_auth_token

  enum role: {
         user: 0,
         admin: 1,
       }

  ### VALIDATIONS ###

  validates :first_name, :last_name, presence: true
  validates :email, uniqueness: true, email: true
  validates :role, inclusion: roles.keys

  has_secure_password

  def auth_token_valid?(token)
    auth_token == token
  end

  def verified?
    !!verified_at
  end

  private

  def generate_auth_token
    self.auth_token = SecureRandom.base64
  end
end
