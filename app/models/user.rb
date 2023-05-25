class User < ApplicationRecord
  ### CONSTANTS ###

  ROLES = {
    user: 0,
    admin: 1
  }

  ### ASSOCIATIONS ###

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address, update_only: true, allow_destroy: true

  ### VALIDATIONS ###

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, email: true

  ### CALLBACKS ###

  before_create :set_auth_token
  before_destroy :check_last_admin
  after_create_commit :send_authentication_email

  ### ENUMS ###

  enum role: ROLES

  has_secure_password

  def auth_token_valid?(token)
    auth_token == token
  end

  def verified
    update(verified_at: Time.now)
  end

  def reset_token_valid?(token)
    reset_token == token
  end

  def generate_reset_token
    update(reset_token: RandomTokenGenerator.new('User', 'auth_token').generate_token)
  end

  def send_authentication_email
    UserMailer.with(user_id: id).confirmation.deliver_later
  end

  def send_password_reset_email
    UserMailer.with(user_id: id).reset_password.deliver_later
  end

  def email_verification_url(host)
    Rails.application.routes.url_helpers.verify_email_url(email: email, token: auth_token, host: host)
  end

  def reset_password_url(host)
    Rails.application.routes.url_helpers.reset_password_edit_url(email: email, token: reset_token, host: host)
  end

  private def set_auth_token
    self.auth_token = RandomTokenGenerator.new('User', 'auth_token').generate_token
  end

  private def check_last_admin
    return unless admin? && User.where(role: :admin).count == 1

    errors.add(:base, 'The last admin cannot be destroyed.')
    throw(:abort)
  end
end
