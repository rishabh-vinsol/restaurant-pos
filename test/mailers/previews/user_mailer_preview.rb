# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirmation
    UserMailer.with(user_id: User.last.id).confirmation.deliver_now
  end
  def reset_password
    UserMailer.with(user_id: User.last.id).reset_password.deliver_now
  end
end
