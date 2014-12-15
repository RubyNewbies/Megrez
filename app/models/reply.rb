class Reply < ActiveRecord::Base

  include TopicsHelper

  validates :source, length: { minimum: 1 }

  belongs_to  :topic
  belongs_to  :user

  before_save :render_body
  after_save  :trigger_topic_update_time

  def render_body
    self.body = markdown(source).html_safe
  end

  def trigger_topic_update_time
    topic = topic()
    if topic
      topic.update_attribute(:updated_at, Time.now)
    end
  end

end
