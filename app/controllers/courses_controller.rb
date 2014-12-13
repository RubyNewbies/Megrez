class CoursesController < ApplicationController

  include UsersHelper

  before_action :signed_in_user, only: [:join, :leave]
  before_action :find_course, except: [:new, :create, :index]

  before_action :check_joined_in,
                only: [:home, :docs, :wiki, :forum, :members, :assmt]

  before_action :check_permission, only: [:update, :destroy, :admin]

  def new
    @course = Course.new
    render 'new.html.erb', layout: 'application'
  end

  def create
    @course = Course.new(course_params.merge user_id: current_user.id)
    @f = Folder.create(name: @course.full_name, parent_id: Folder.root.id)
    if @course.save
      rel = {user_id: @course.user_id, course_id: @course.id}
      @course.course_user_relationships.create(rel)
      @f.course_id = @course.id
      @f.save
      redirect_to @course
    end
  end

  def index
    @do_not_show_nav = true
    @courses = Course.all
    render 'index.html.erb', layout: 'application'
  end

  def show
    if current_user && current_user.joined_in_course?(@course.id)
      redirect_to home_course_path(@course)
    else
      @do_not_show_nav = true
      render 'introduce.html.erb', layout: 'application'
    end
  end

  def home
  end

  def destroy
    if check_permission
      @course.delete
      # Should send some email or message to notify?
      redirect_to '/', success: '成功删除。'
    else
    end
  end

  def docs
    @folders = Folder.where(course_id: params[:id])
  end

  def forum
    @nodes = Node.where(course_id: params[:id], father_id: -1)
    render 'forum.html.erb', layout: false
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

  def join
    unless current_user.joined_in_course?(params[:id])
      current_user.join_in_course(params[:id])
    end
    redirect_to @course
  end

  def leave
    if current_user.joined_in_course?(params[:id])
      current_user.leave_out_course(params[:id])
      redirect_to @course
    else
      redirect_to @course, error: '你还没有加入此课程。'
    end
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
    unless current_user.joined_in_course?(params[:id].to_i)
      redirect_to course_path(@course)
    end
  end

  def check_permission
    true
    # current_user.id == creator.id
  end
  
end
