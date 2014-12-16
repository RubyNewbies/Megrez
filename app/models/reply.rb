class Reply < ActiveRecord::Base

  include TopicsHelper

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
    # unless user.id == topic.user.id
    #   hash = user_id: topic.user.id, content: ''
    #   Notification.create()
    # end
  end

end
