class User < ActiveRecord::Base

  #include ActiveModel::ForbiddenAttributesProtection

  has_attached_file :avatar, styles: { medium: "220x220>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :avatar, :content_type => /\Aimage/
  validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]
  do_not_validate_attachment_file_type :avatar

  has_many  :created_courses, class_name: 'Course'

  has_many  :courses, through: :course_user_relationships
  has_many  :course_user_relationships, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    email: {:strict_mode => true}

  before_save {self.email = email.downcase}
  before_create :create_remember_token

  has_secure_password
  validates :password, length: { in: 6..20 }, on: :create

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def creator_of_course?(course_id)
    course = Course.find(course_id)
    course.creator_id == id
  end

  def joined_in_course?(course_id)
    course_user_relationships.where(course_id: course_id, user_id: id).first
  end

  def join_in_course(course_id)
    course_user_relationships.create(course_id: course_id, user_id: id)
  end

  def leave_out_course(course_id)

    # if creator leaves out the course, the course will be delete
    if creator_of_course?(course_id)
      delete
    elsif joined_in_course?(course_id)
      course_user_relationships.where(course_id: course_id, user_id: id).
                                first.try(:delete)
    else
      false
    end

  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
