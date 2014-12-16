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
    @notifiaction = Notification.find(params[:id])
    @notifiaction.update_attribute(:unread, false)
    redirect_to @notifiaction.target_url
  end

  def ignore
    @notifiaction = Notification.find(params[:id])
    @notifiaction.update_attribute(:unread, false)
    
    respond_to do |respond|
      respond.js
    end
  end

  def mark_all
    @notifiactions = Notification.where(user_id: current_user.id, unread: true)
    @notifiactions.update_all(unread: false)

    respond_to do |respond|
      respond.js
    end
  end
  
end
