class Topic < ActiveRecord::Base

  include TopicsHelper
  include Rails.application.routes.url_helpers

  validates :title, length: { in: 1..120  }

  has_many  :replies
  belongs_to  :user
  belongs_to  :node

  before_save :render_body
  after_save :send_notifications

  # Credit for this regular expression
  # https://github.com/daqing/rabel/blob/master/app/models/notifiable.rb
  MENTION_REGEXP = /@([a-zA-Z0-9_\-\p{han}]+)/u

  def render_body
    self.body = self.source
    self.body.gsub!(MENTION_REGEXP) do |match|
      if u = User.find_by_username(match[1..-1])
        ActionController::Base.helpers.link_to match, profile_path(username: match[1..-1])
      end
    end
    self.body = markdown(source).html_safe
  end

  def mentioned_users
    mentioned_names = source.scan(MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(user.username)
    mentioned_names.map { |name| User.where(username: name).first }.compact
  end

  def course
    Course.find(node.id)
  end

  private

  def send_notifications
    username = "@#{user.username}(#{user.realname})"
    user_url = ActionController::Base.helpers.link_to username, profile_path(username: user.username)
    message = "#{user_url}在#{title}中提到了你。"
    target_url = course_topic_path(course_id: node.course.id, id: id)
    mentioned_users.each do |u|
      Notification.create(user_id: u.id, content: message, target_url: target_url)
    end
  end

end
