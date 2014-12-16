class User < ActiveRecord::Base

  #include ActiveModel::ForbiddenAttributesProtection
  has_and_belongs_to_many :groups
  has_many :share_links  


  has_attached_file :avatar, styles: { medium: "220x220>", thumb: "100x100>" }, default_url: "missing.jpg"

  #validates_attachment_content_type :avatar, :content_type => /\Aimage/
  do_not_validate_attachment_file_type :avatar

  has_many  :created_courses, class_name: 'Course'
  has_many  :topics

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

  after_create :create_root_folder_and_admins_group

  %w{create read update delete}.each do |method|
    define_method "can_#{method}" do |folder|
      has_permission = false

      Permission.where(:group_id => groups, :folder_id => folder.id).each do |permission|
        has_permission = permission.send("can_#{method}")
        break if has_permission
      end

      has_permission
    end
  end

  # def member_of_admins?
  #   groups.admins_group.present?
  # end

  # def refresh_reset_password_token
  #   self.reset_password_token = SecureRandom.hex(10)
  #   self.reset_password_token_expires_at = 1.hour.from_now
  #   self.dont_clear_reset_password_token = true
  #   save(:validate => false)
  # end

  def refresh_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
    save(:validate => false)
  end

  # def forget_me
  #   self.remember_token = nil
  #   save(:validate => false)
  # end

  # def username_is_blank?
  #   self.username.blank?
  # end

  # def self.authenticate(username, password)
  #   return nil if username.blank? || password.blank?
  #   user = find_by_username(username) or return nil
  #   hash = Digest::SHA256.hexdigest(user.password_salt + password)
  #   hash == user.hashed_password ? user : nil
  # end

  # def self.no_admin_yet?
  #   find_by_is_admin(true).blank?
  # end

  # private

  # def set_signup_token
  #   self.signup_token = SecureRandom.hex(10)
  #   self.signup_token_expires_at = 2.weeks.from_now
  # end

  # def clear_signup_token
  #   unless self.username.blank?
  #     self.signup_token = nil
  #     self.signup_token_expires_at = nil
  #   end
  # end

  # def clear_reset_password_token
  #   self.reset_password_token = nil
  #   self.reset_password_token_expires_at = nil
  # end

  def create_root_folder_and_admins_group
    @root_folder = Folder.find_by_name('Root folder')
    @admins = Group.find_by_name('Admins')
    Folder.create(:name => 'Root folder') if @root_folder.nil? 
    Folder.create(:name => self.username, :parent_id => Folder.root.id)
    groups << Group.create(:name => 'Admins') if @admins.nil?
  end

  # def dont_destroy_admin
  #   raise "Can't delete original admin user" if is_admin
  # end

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

  def final(course_id)
    fathers = Item.where(course_id: course_id, father_id: -1)
    res = fathers.inject(0) do |memo, item|
      val = item.count(id)
      memo + (val.nil? ? 0 : val)
    end
    [res, 100].min.round(2)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
