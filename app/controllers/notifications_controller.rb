class NotificationsController < ApplicationController

  def index
    @notifications = Notification.where(user_id: current_user.id, unread: true)
    @notifications.update_all(unread: true)
    respond_to do |respond|
      respond.html
      respond.js
    end
  end

  def mark_all_as_read
    @notifications = Notification.where(user_id: current_user.id, unread: true)
    @notifications.update_all(unread: true)

    respond_to do |respond|
      respond.html
      respond.js
    end
  end

  def readed
    @notifications = Notification.where(user_id: current_user.id, unread: false)
  end
  
end
