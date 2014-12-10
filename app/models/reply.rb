class Reply < ActiveRecord::Base

  include TopicsHelper

  validates :source, length: { minimum: 1 }

  belongs_to  :topic

  before_save :render_body

  def render_body
    self.body = markdown(source).html_safe
  end

end
