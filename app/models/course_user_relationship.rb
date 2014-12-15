class CourseUserRelationship < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true
end
