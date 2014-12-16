class Message < ActiveRecord::Base

  def receiver
    User.find_by_id(receiver_id)
  end

  def sender
    User.find_by_id(sender_id)
  end

end
