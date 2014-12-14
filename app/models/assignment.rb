class Assignment < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :course
  has_attached_file :submission

  def end_time
    DateTime.parse(due_to.to_s).strftime('%Y-%m-%d %H:%M').to_s
  end

end
