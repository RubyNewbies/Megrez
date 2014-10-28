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
      render 'show.html.erb'
    else
      render 'introduce.html.erb'
    end
  end

  def destroy
  end

  def docs
  end

  def forum
  end

  def members
  end

  def admin
  end

  def wiki
  end

  private

  def course_params
    params.require(:course).permit(:department_id, :full_name,
                                   :english_name, :key, :description)
  end
  
end
