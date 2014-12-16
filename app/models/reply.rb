class Reply < ActiveRecord::Base

  include TopicsHelper
  include Rails.application.routes.url_helpers

  # Credit for this regular expression
  # https://github.com/daqing/rabel/blob/master/app/models/notifiable.rb
  MENTION_REGEXP = /@([a-zA-Z0-9_\-\p{han}]+)/u

  validates :source, length: { minimum: 1 }

  belongs_to  :topic
  belongs_to  :user

  before_save :render_body
  after_save  :notify_topic_author
  after_save  :send_notifications
  after_create  :trigger_topic_update_time

  def render_body
    self.body = self.source.clone
    self.body.gsub!(MENTION_REGEXP) do |match|
      if u = User.find_by_username(match[1..-1])
        ActionController::Base.helpers.link_to match, profile_path(username: match[1..-1])
      end
    end
    self.body = markdown(body).html_safe
  end

  def trigger_topic_update_time
    if topic
      topic.update_attribute(:updated_at, Time.now)
    end
  end

  def mentioned_users
    mentioned_names = source.scan(MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(user.username)
    mentioned_names.map { |name| User.where(username: name).first }.compact
  end

  private

  def notify_topic_author
    unless user.id == topic.user.id
      url = course_topic_path(id: topic.id, course_id: topic.node.course_id) + "#reply-#{id}"
      user_url = ActionController::Base.helpers.link_to "@#{user.username}(#{user.realname})", profile_path(user.username)
      message = "#{user_url} 在 #{topic.title} 中回复了你。"
      Notification.create(user_id: topic.user.id, content: message, target_url: url)
      puts "-"*20
      puts "Notification Created!"
    end
  end

  def send_notifications
    username = "@#{user.username}(#{user.realname})"
    user_url = ActionController::Base.helpers.link_to username, profile_path(username: user.username)
    message = "#{user_url}在#{topic.title}的回复中提到了你。"
    target_url = course_topic_path(course_id: topic.node.course.id, id: topic.id) + "#reply-#{id}"
    mentioned_users.each do |u|
      Notification.create(user_id: u.id, content: message, target_url: target_url)
    end
  end

end
