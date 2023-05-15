module Authenticatable
  extend ActiveSupport::Concern

  included do
    after_create_commit :send_authentication_email
  end

  def send_authentication_email
    UserMailer.with(user_id: id).confirmation.deliver_now
  end

  def send_password_reset_email
    UserMailer.with(user_id: id).reset_password.deliver_now
  end
end
