class UsersController < ApplicationController

  include UsersHelper

  def index
    @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
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
      redirect_to dashboard_path
    else
      render :new, layout: 'static_pages'
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

  def grade
    @course = Course.find(params[:id])
    @user = User.find(params[:user_id])
    @items = Item.where(course_id: params[:id], father_id: -1)
    render 'grade.html.erb', layout: 'courses'
  end

  private

  def user_params
    params.require(:user).permit(:username, :realname, :password, :email)
  end

end
