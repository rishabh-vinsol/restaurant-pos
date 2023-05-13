class UserMailer < ApplicationMailer
  default from: "rishk1724@gmail.com"

  def confirmation
    @user = User.find_by(id: params[:user_id])
    mail(to: @user.email)
  end
end
