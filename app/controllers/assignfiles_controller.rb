class AssignfilesController < ApplicationController

  def create
    @assignfile = Assignfile.create(assignfile_params)
  end

  def update
    @assignfile = Assignfile.find(params[:id])
    @assignfile.update!(assignfile_params)
    @assignment = Assignment.find(@assignfile.assignment_id)
    redirect_to course_assignment_path(course_id: @assignment.course.id, id: @assignment.id)
  end

  private

  def assignfile_params
    params.require(:assignfile).permit(:assignment_id, :user_id, :source)
  end

end
