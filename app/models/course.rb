class Course < ActiveRecord::Base

  validate  :full_name, presence: true, length: { in: 1..40 }

  belongs_to :user

end
