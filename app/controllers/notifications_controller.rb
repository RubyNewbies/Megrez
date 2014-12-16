class NotificationsController < ApplicationController

  def index
    @notifications = Notification.where(user_id: current_user.id, unread: true)
    @notifications.update_all(unread: true)
    respond_to do |respond|
      respond.html
      respond.js
    end
  end

  def go
    @notification = Notification.find(params[:id])
    @notification.update_attribute(:unread, false)
    redirect_to @notification.target_url
  end

  def ignore
    @notification = Notification.find(params[:id])
    @notification.update_attribute(:unread, false)
    
    respond_to do |respond|
      respond.js
    end
  end

  def mark_all
    @notifications = Notification.where(user_id: current_user.id, unread: true)
    @notifications.update_all(unread: false)

    respond_to do |respond|
      respond.js
    end
  end
  
end
