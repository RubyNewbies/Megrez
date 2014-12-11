class Topic < ActiveRecord::Base

  include TopicsHelper
  include UsersHelper

  validates :title, length: { in: 1..120, too_short: "标题至少%{count}个字符", too_long: "标题至多%{count}个字符" }

  has_many  :replies
  belongs_to  :node

  before_save :render_body

  # Credit for this regular expression
  # https://github.com/daqing/rabel/blob/master/app/models/notifiable.rb
  MENTION_REGEXP = /@([a-zA-Z0-9_\-\p{han}]+)/u

  def render_body
    self.body = markdown(source).html_safe
  end

  def mentioned_users
    mentioned_names = body.scan(MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(current_user.username)
    mentioned_names.map { |name| User.where(username: name).first }.compact
  end


  def send_notifications
    mentioned_users.each do |user|
      user_url = link_to current_user.username, profile_path(username: current_user.username) 
      topic_url = link_to title, course_topic_path(self)
      notification = "#{user_url}在#{topic_url}中提到了你。"
      puts "Create notification: " + notification
      Notification.create(user, notification)
    end
  end

end
