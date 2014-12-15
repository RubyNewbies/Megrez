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

  def profile 
    @user = User.where(username: params[:username]).first
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
    @user.update_attribute(:avatar, params[:user][:avatar])
    @user.update_attribute(:preferred_lang, params[:user][:preferred_lang])
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

  def extend
    @user.signup_token_expires_at = @user.signup_token_expires_at + 2.weeks
    @user.save(:validate => false)
    redirect_to users_url
  end

  # Note: @user is set in require_existing_user
  def destroy
    @user.destroy
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :realname, :password, :email)
  end

  def require_existing_user
    if current_user.member_of_admins? && params[:id] != current_user.id.to_s
      @title = t(:edit_user)
      @user = User.find(params[:id])
    else
      @title = t(:account_settings)
      @user = current_user
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, :alert => t(:user_already_deleted)
  end

  def require_deleted_user_isnt_admin
    if @user.is_admin
      redirect_to users_url, :alert => t(:admin_user_cannot_be_deleted)
    end
  end
end
