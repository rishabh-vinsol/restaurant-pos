class User < ApplicationRecord
  include Authenticatable
  before_create :generate_auth_token

  enum role: {
         user: 0,
         admin: 1,
       }

  ### VALIDATIONS ###

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, email: true

  has_secure_password

  def auth_token_valid?(token)
    auth_token == token
  end

  def update_verified_at
    update(verified_at: Time.now)
  end

  private

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.base64
      break unless User.exists?(auth_token: auth_token)
    end
  end
end
