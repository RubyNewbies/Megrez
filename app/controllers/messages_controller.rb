class MessagesController < ApplicationController

  def new
    @user = User.where(username: params[:username]).first
    send_by_me = Message.where(sender_id: current_user.id, receiver_id: @user.id)
    send_by_user = Message.where(sender_id: @user.id, receiver_id: current_user.id)
    @messages = (send_by_user + send_by_me).sort_by(&:created_at)
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge sender_id: current_user.id)
    if @message.save
      respond_to do |respond|
        respond.js
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :content)
  end

end
