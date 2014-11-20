class Reply < ActiveRecord::Base

  validates :source, length: { minimum: 1 }
  validates :body, length: { minimum: 1 }

  belongs_to  :topic

end
