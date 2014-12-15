class SessionsController < ApplicationController

  include UsersHelper

  #skip_before_filter :verify_authenticity_token, only: [:create]

  def new
    @user = User.new
  end

  def create
    user = User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      cookies[:auth_token] = { :value => user.remember_token, :expires => 2.weeks.from_now }
      redirect_to '/dashboard'
    else
      flash[:error] = I18n.t(:failed)
      render :new, layout: 'static_pages'
    end
  end

  def destroy
    cookies.delete :auth_token
    sign_out if signed_in?
    redirect_to root_path
  end

  private

  def log_failed_sign_in_attempt(date, username, ip)
    Rails.logger.error(
      "\nFAILED SIGN IN ATTEMPT:\n" +
      "=======================\n" +
      " Date: #{date}\n" +
      " Username: #{username}\n" +
      " IP address: #{ip}\n\n"
    )
  end

end
