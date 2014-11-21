class UsersController < ApplicationController

  include UsersHelper

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def dashboard
    @user = signed_in_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to @user
    else
      render :new
    end
  end

  def update
    @user = current_user
    @user.update(user_params)
    redirect_to dashboard_path
  end

  def me
    render signed_in_user 
  end

  private

  def user_params
    params.require(:user).permit(:username, :realname, :password, :email)
  end

end
