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
    @user_folder = Folder.find_by_name(current_user.username)
    @course_folder = Folder.create(name: "(Course folder)#{@course.full_name}", parent_id: @user_folder.id)
    @doc_folder = Folder.create(name: "Documents", parent_id: @course_folder.id, is_doc: true)
    if @course.save
      rel = {user_id: @course.user_id, course_id: @course.id}
      @course.course_user_relationships.create(rel)
      @course_folder.course_id = @course.id
      @doc_folder.course_id = @course.id
      @course_folder.save
      @doc_folder.save
      @groups = Group.all
      @groups << Group.create(:name => @course.full_name)
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
    @activities = PublicActivity::Activity.order("created_at desc")
    @announcements = Announcement.where(course_id: params[:id]).order("created_at desc")
  end

  def destroy
    if check_permission
      user_folder = Folder.find_by_name(current_user.username)
      @course_folder = Folder.find_by(name: "(Course folder)#{@course.full_name}", parent_id: user_folder.id)
      @course.delete
      @course_folder.destroy
      # Should send some email or message to notify?
      redirect_to '/', success: I18n.t(:deleted_successfully)
    else
      redirect_to @course, error: I18n.t(:not_creator)
    end
  end

  def sort_column
    column = params[:sort] == "attachment_file_size" ? "attachment_file_size" : "LOWER(#{params[:sort]})"
    UserFile.column_names.include?(params[:sort]) ? column : "attachment_file_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def docs
    @folder = Folder.find_by(course_id: params[:id], is_doc: true)
    @files = @folder.user_files.order(sort_column + " " + sort_direction).search(params[:query]).paginate :page => params[:page], :per_page => 10

  end

  def forum
    @nodes = Node.where(course_id: params[:id], father_id: -1)
    render 'forum.html.erb', layout: 'forums'
  end

  def members
    @members = @course.users
  end

  def admin
  end

  def info
    @course = Course.find(params[:id])
  end

  def assignment_management
    @course = Course.find(params[:id])
    @assignments = Assignment.where(course_id: @course.id)
    @users = @course.users - User.where(id: @course.creator_id)
    @total_num = @users.size
    @submitted_num = []
    @assignments.each_with_index do |assignment, i|
      @submitted_num[i] = 0
      @users.each do |user|
        if assignment.is_submitted_by?(user, @course)
          @submitted_num[i] += 1
        end
      end
    end
  end

  def statistics
    @course = Course.find(params[:id])
    @assignments = Assignment.where(course_id: @course.id)
    @posts = Topic.where(params[:id])
    @users = @course.users - User.where(id: @course.creator_id)
  end

  def grade
    @course = Course.find(params[:id])
    @users = @course.users - User.where(id: @course.creator_id)
  end

  def final
    @course = Course.find(params[:id])
    @users = @course.users - User.where(id: @course.creator_id)
  end

  def wiki
  end

  def assmt
  end

  def edit
    @course = Course.find(params[:id])
    render 'edit.html.erb', layout: 'application'
  end

  def update
    @course = Course.find(params[:id])
    @course.update(course_params)
    redirect_to info_course_path(id: @course.id)
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
      redirect_to @course, error: I18n.t(:not_joined_yet)
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
    @course = Course.find(params[:id])
    current_user.id == @course.creator.id
  end
  
end
