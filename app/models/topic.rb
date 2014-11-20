class Topic < ActiveRecord::Base

  validates :title, length: { in: 1..30, too_short: "标题至少%{count}个字符", too_long: "标题至多%{count}个字符" }

  has_many  :replies
  belongs_to  :node

end
