class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

  has_attached_file :avatar, styles: { medium: "120x120>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

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
  validates :password, length: { in: 6..20  }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def course_joined_in?(course_id)
    courses.any? {|c| c.id == course_id}
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
