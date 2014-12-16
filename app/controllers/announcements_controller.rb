class AnnouncementsController < ApplicationController
  def index
    @announcements = Announcement.where(course_id: params[:course_id])
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.save
    redirect_to course_announcements_path(course_id: params[:course_id])
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])
    @announcement.update(announcement_params)
    redirect_to course_announcements_path(course_id: params[:course_id])
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.delete
    redirect_to course_announcements_path(course_id: params[:course_id])
  end

  def announcement_params
    params.require(:announcement).permit(:content, :course_id)
  end

end
