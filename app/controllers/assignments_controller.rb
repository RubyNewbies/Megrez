class AssignmentsController < ApplicationController

  include UsersHelper

  def index
  end

  def new
    @assignment = Assignment.new
  end

  def show
    @assignment = Assignment.find(params[:id])
    @assignment = Assignment.find(params[:id])
    @assignment_folder = Folder.find_by(name: "Assignment:#{@assignment.title}", course_id: params[:course_id], is_assignment: true)
    @target_folder = Folder.find_by(name: current_user.username, parent_id: @assignment_folder.id)
    @files = @target_folder.user_files unless @target_folder.nil?
    render 'show', layout: false
  end

  def destroy
  end

  def edit
    @assignment = Assignment.find(params[:id])
  end

  def update
    @assignment = Assignment.find(params[:id])
    @assignment.update!(assignment_params)
    redirect_to course_assignment_path(course_id: params[:course_id], id: params[:id])
  end

  def create
    @assignment = Assignment.new(assignment_params)
    @assignment.save
    @course = Course.find(params[:course_id])
    @folder = Folder.create(name: "Assignment:#{@assignment.title}", course_id: params[:course_id], parent_id: Folder.find_by_course_id(@course.id).id, is_assignment: true)
    redirect_to course_assignments_path(course_id: params[:course_id])
  end

  def submit
    @course = Course.find(params[:course_id])
    @assignment = Assignment.find(params[:id])
    @assignment_folder = Folder.find_by(name: "Assignment:#{@assignment.title}", course_id: params[:course_id], is_assignment: true)
    @target_folder = Folder.find_by(name: current_user.username, parent_id: @assignment_folder.id)
    if @target_folder.nil?
      @target_folder = Folder.create(name: current_user.username, parent_id: @assignment_folder.id, is_assignment: false)
      @target_folder.save!
    end
    @file = @target_folder.user_files.build
  end

  def inspect
    @course = Course.find(params[:course_id])
    @assignment = Assignment.find(params[:id])
    @assignment_folder = Folder.find_by(name: "Assignment:#{@assignment.title}", course_id: params[:course_id], is_assignment: true)
    @files = []
    @students = []
    @assignment_folder.children.each do |student|
      @files << student.user_files
      @students << student.name
    end
  end

  def upload
    @assignment = Assignment.find(params[:id])
    @target_folder = Folder.find(params[:target_folder_id])
    @target_folder.user_files.create(params[:attachment])
    redirect_to course_assignment_path(course_id: params[:course_id], id: params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:title, :description, :course_id, :due_to)
  end

end
