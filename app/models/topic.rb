class Topic < ActiveRecord::Base

  include TopicsHelper

  validates :title, length: { in: 1..120, too_short: "标题至少%{count}个字符", too_long: "标题至多%{count}个字符" }

  has_many  :replies
  belongs_to  :node

  before_save :render_body

  def render_body
    self.body = markdown(source).html_safe
  end

end
