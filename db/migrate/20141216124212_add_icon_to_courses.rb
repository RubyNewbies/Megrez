class AddIconToCourses < ActiveRecord::Migration
  def change
    add_attachment :courses, :icon
  end
end
