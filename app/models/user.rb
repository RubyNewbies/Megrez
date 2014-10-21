class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection

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

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
