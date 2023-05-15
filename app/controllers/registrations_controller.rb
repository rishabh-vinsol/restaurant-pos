# Controller to signup new users
class RegistrationsController < ApplicationController
  layout 'user'
  skip_before_action :authorize
  before_action :redirect_to_homepage_if_logged_in
  before_action :initialize_user, only: :create
  
  def new
    @user = User.new
  end

  def create
    if @user.save
      redirect_to login_url, alert: t('.verify_email')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private def initialize_user
    @user = User.new(user_params)
  end

  private def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
