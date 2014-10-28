class CoursesController < ApplicationController

  include UsersHelper

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params.merge user_id: current_user.id)
    if @course.save
      redirect_to @course
    else
    end
  end

  def index 
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    if current_user.course_joined_in?(params[:id])
      render 'show.html.erb'
    else
      render 'introduce.html.erb'
    end
  end

  def destroy
  end

  private

  def course_params
    params.require(:course).permit(:department_id, :full_name,
                                   :english_name, :key, :description)
  end
  
end
