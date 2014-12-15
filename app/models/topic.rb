class Topic < ActiveRecord::Base

  include TopicsHelper

  validates :title, length: { in: 1..120  }

  has_one   :user
  has_many  :replies
  belongs_to  :node

  before_save :render_body
  after_save :send_notifications

  # Credit for this regular expression
  # https://github.com/daqing/rabel/blob/master/app/models/notifiable.rb
  MENTION_REGEXP = /@([a-zA-Z0-9_\-\p{han}]+)/u

  def render_body
    self.body = markdown(source).html_safe
  end

  def mentioned_users
    mentioned_names = body.scan(MENTION_REGEXP).collect {|matched| matched.first}.uniq
    mentioned_names.delete(user.username)
    mentioned_names.map { |name| User.where(username: name).first }.compact
  end

  private

  def send_notifications
    user = User.find(user_id)
    user_url = "<a href=\"/u/#{user.username}\">#{user.username}</a>"
    mentioned_users.each do |user|
      notification = I18n.t(:notification)
      puts "Create notification: " + notification
      Notification.create(user, notification)
    end
  end

end
