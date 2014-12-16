class RepliesController < ApplicationController

  include UsersHelper

  def create
    @reply = Reply.new(replies_params.merge user_id: current_user.id)
    @topic = Topic.find(replies_params[:topic_id])
    if @reply.save
      respond_to do |respond|
        respond.html
        respond.js   { render 'replies/create.js.erb', locals: {topic_author: @topic.user.id} }
      end
    end
  end

  def edit
    @reply = Reply.find(params[:id])
  end

  def update
    @reply = Reply.find(params[:id])
    if @reply.update_attributes(replies_update_params)
      @topic = @reply.topic
      @course = @topic.course
      redirect_to course_topic_path(id: @topic.id, course_id: @course.id) + "#reply-#{@reply.id}"
    end
  end

  private

  def replies_params
    params.require(:reply).permit(:topic_id, :source)
  end

  def replies_update_params
    params.require(:reply).permit(:source)
  end

end
