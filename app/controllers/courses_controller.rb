class CoursesController < ApplicationController

  include UsersHelper

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params.merge user_id: current_user.id)
    if @course.save
      rel = {user_id: @course.user_id, course_id: @course.id}
      @course.course_uesr_relationships.create(rel)
      redirect_to @course
    else
    end
  end

  def index 
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    if current_user.course_joined_in?(@course.id)
      redirect_to home
    else
      render 'introduce.html.erb'
    end
  end


  def home
    @course = Course.find(params[:id])
  end

  def destroy
    @course = Course.find(params[:id])
  end

  def docs
    @course = Course.find(params[:id])
  end

  def forum
    @course = Course.find(params[:id])
  end

  def members
    @course = Course.find(params[:id])
    @members = @course.users
  end

  def admin
    @course = Course.find(params[:id])
  end

  def wiki
    @course = Course.find(params[:id])
  end

  def assmt
    @course = Course.find(params[:id])
  end

  private

  def course_params
    params.require(:course).permit(:department_id, :full_name,
                                   :english_name, :key, :description)
  end
  
end
