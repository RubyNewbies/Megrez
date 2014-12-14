class AddCourseIdToFolders < ActiveRecord::Migration
  def change
    add_reference :folders, :course
    remove_column :folders, :courses_id
  end
end
