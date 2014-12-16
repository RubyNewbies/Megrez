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
    receiver_id = message_params[:receiver_id]
    if @message.save
      user = User.find_by_id(receiver_id)
      by = ActionController::Base.helpers.link_to "@#{current_user.username}(#{current_user.realname})",
           profile_path(current_user.username)
      target_url = new_pm_path(username: current_user.username)
      notification = "#{by} #{t :leave_a_message_for_you}"

      Notification.create(user_id: receiver_id, content: notification, target_url: target_url)
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
