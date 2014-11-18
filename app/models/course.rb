class Course < ActiveRecord::Base

  validate :full_name, presence: true, length: { in: 1..40 }

  has_many :course_user_relationships, dependent: :destroy
  has_many :users, through: :course_user_relationships

  def creator
    User.find(user_id)
  end

  def join_user(user)
    unless user.course_joined_in?(id)
      rel = {user_id: user.id, course_id: id}
      course = course_user_relationships.new(rel)
      return course.save
    end
  end

  def full_name_with_creator_name
    "#{full_name} · #{creator.username}"
  end

end
