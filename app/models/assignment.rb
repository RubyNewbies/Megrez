class Assignment < ActiveRecord::Base

  include PublicActivity::Model
  tracked

  belongs_to :course

  def end_time
    DateTime.parse(due_to.to_s).strftime('%Y-%m-%d %H:%M').to_s
  end

end
