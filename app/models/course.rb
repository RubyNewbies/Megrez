class Course < ActiveRecord::Base

  validate :full_name, presence: true, length: { in: 1..40 }

  has_many :course_user_relationships, dependent: :destroy
  has_many :users, through: :course_user_relationships

  has_many :nodes
  has_attached_file :icon, styles: { medium: "220x220>", thumb: "100x100>" }, default_url: "icon/books8.png"
  validates_attachment_content_type :icon, :content_type => /\Aimage/
  do_not_validate_attachment_file_type :icon
  def creator
    User.find(user_id)
  end

  def creator_id
    user_id
  end

  def join_user(user)
    unless user.course_joined_in?(id)
      rel = {user_id: user.id, course_id: id}
      course = course_user_relationships.new(rel)
      return course.save
    end
  end

  def full_name_with_creator_name
    "#{full_name} · #{creator.realname}"
  end

  def direct_nodes
    nodes.where(father_id: -1)
  end

  def latest_assignments
    Assignment.where("course_id = ? and due_to >= ?", id, Time.now).order("due_to")
  end

end
