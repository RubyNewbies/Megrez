class Assignment < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :course

  def end_time
    DateTime.parse(due_to.localtime.to_s).strftime('%Y-%m-%d %H:%M').to_s
  end

  def start_time
    DateTime.parse(created_at.localtime.to_s).strftime('%Y-%m-%d %H:%M').to_s
  end

  def is_submitted?(user)
    false
  end

end
