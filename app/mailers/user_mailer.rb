class UserMailer < ApplicationMailer
  default from: Rails.application.secrets.gmail_username

  def confirmation
    @user = User.find_by(id: params[:user_id])
    mail(to: @user.email)
  end
end
