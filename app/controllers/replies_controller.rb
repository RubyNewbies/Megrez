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

  private

  def replies_params
    params.require(:reply).permit(:topic_id, :source)
  end

end
