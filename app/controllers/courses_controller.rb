class CoursesController < ApplicationController

  include UsersHelper

  before_action :find_course, except: [:new, :create, :index]

  before_action :check_joined_in,
                only: [:home, :docs, :wiki, :forum, :members, :assmt]

  before_action :check_permission, only: [:update, :destroy, :admin]

  def new
    @do_not_show_nav = true
    @course = Course.new
  end

  def create
    @course = Course.new(course_params.merge user_id: current_user.id)
    if @course.save
      rel = {user_id: @course.user_id, course_id: @course.id}
      @course.course_user_relationships.create(rel)
      redirect_to @course
    else
    end
  end

  def index
    @do_not_show_nav = true
    @courses = Course.all
  end

  def show
    if current_user && current_user.course_joined_in?(@course.id)
      redirect_to home_course_path(@course)
    else
      @do_not_show_nav = true
      render 'introduce.html.erb'
    end
  end


  def home
  end

  def destroy
  end

  def docs
  end

  def forum
  end

  def members
    @members = @course.users
  end

  def admin
  end

  def wiki
  end

  def assmt
  end

  def update
    @course.update(course_params)
    redirect_to @course
  end

  private

  def course_params
    params.require(:course).permit(:department_id, :full_name,
                                   :english_name, :key, :description)
  end

  def find_course
    @course = Course.find(params[:id])
  end

  def check_joined_in
    unless current_user.course_joined_in?(params[:id].to_i)
      redirect_to course_path(@course)
    end
  end

  def check_permission
    true
  end
  
end
