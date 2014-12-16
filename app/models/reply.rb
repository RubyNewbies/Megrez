class Reply < ActiveRecord::Base

  include TopicsHelper
  include Rails.application.routes.url_helpers

  validates :source, length: { minimum: 1 }

  belongs_to  :topic
  belongs_to  :user

  before_save :render_body
  after_save  :notify_topic_author
  after_create  :trigger_topic_update_time

  def render_body
    self.body = markdown(source).html_safe
  end

  def trigger_topic_update_time
    if topic
      topic.update_attribute(:updated_at, Time.now)
    end
  end

  private

  def notify_topic_author
    unless user.id == topic.user.id
      url = course_topic_path(id: topic.id, course_id: topic.node.course_id) + "#reply-#{id}"
      link = "<a href=\"#{url}\">#{topic.title}</a>"
      user_url = ActionController::Base.helpers.link_to "@#{user.username}(#{user.realname})", profile_path(user.username)
      message = "#{user_url} 在 #{link} 中回复了你"
      Notification.create(user_id: topic.user.id, content: message)
      puts "-"*20
      puts "Notification Created!"
    end
  end

end
