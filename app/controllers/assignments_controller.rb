class AssignmentsController < ApplicationController

  include UsersHelper

  def index
  end

  def new
    @assignment = Assignment.new
  end

  def show
    @assignment = Assignment.find(params[:id])
    @assignfile = Assignfile.where(assignment_id: @assignment.id, user_id: current_user.id).first
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
    redirect_to course_assignments_path(course_id: params[:course_id])
  end

  def submit
    @assignment = Assignment.find(params[:id])
    @assignfile = Assignfile.where(assignment_id: @assignment.id, user_id: current_user.id).first_or_create
  end

  def assignment_params
    params.require(:assignment).permit(:title, :description, :course_id, :due_to)
  end

end
