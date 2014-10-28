class Course < ActiveRecord::Base

  validate :full_name, presence: true, length: { in: 1..40 }

  has_many :course_user_relationships, dependent: :destroy
  has_many :users, through: :course_user_relationships

  def creator
    User.find(user_id)
  end

end
