class UserMailer < ApplicationMailer
  before_action :set_host
  default from: Rails.application.secrets.gmail_username

  def confirmation
    @user = User.find_by(id: params[:user_id])
    mail(to: @user.email)
  end

  def reset_password
    @user = User.find_by(id: params[:user_id])
    mail(to: @user.email)
  end

  private def set_host
    @host = Rails.application.config.action_mailer.default_url_options[:host]
  end
end
