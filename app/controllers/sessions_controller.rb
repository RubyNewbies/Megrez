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
      redirect_to user
    else
      flash[:error] = '账号/密码错误！'
      render 'new'
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_path
  end

end
