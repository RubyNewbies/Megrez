class Node < ActiveRecord::Base

  validates :name, length: { in: 1..8, too_short: "名称至少%{count}个字符", too_long: "名称至多%{count}个字符" }

  belongs_to :course
  
  has_many  :topics

  def children
    Node.where(father_id: id)
  end

end