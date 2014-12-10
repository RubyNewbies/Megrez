class RepliesController < ApplicationController

  include UsersHelper

  def create
    @reply = Reply.new(replies_params.merge user_id: current_user.id)

    if @reply.save
      respond_to do |respond|
        respond.html
        respond.js
      end
    end
  end

  private

  def replies_params
    params.require(:reply).permit(:topic_id, :source)
  end

end
