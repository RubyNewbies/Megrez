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

  def very_important?
    due_to.to_i - Time.now.to_i <= 86400
  end

  def remain_hour
    ((due_to.to_i - Time.now.to_i) % 86400) / 3600
  end

  def remain_minute
    (((due_to.to_i - Time.now.to_i) % 86400) % 3600) / 60
  end

  def remain_second
    (((due_to.to_i - Time.now.to_i) % 86400) % 3600) % 60
  end

  def is_submitted_by?(student, course)
    assignment_folder = Folder.find_by(name: "Assignment:#{self.title}", course_id: course.id, is_assignment: true)
    target_folder = Folder.find_by(name: student.username, parent_id: assignment_folder.id)
    files = target_folder.user_files unless target_folder.nil?
    !(target_folder.nil? || files.nil? || files.empty?)
  end

end
