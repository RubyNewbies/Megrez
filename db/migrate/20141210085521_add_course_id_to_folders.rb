class AddCourseIdToFolders < ActiveRecord::Migration
  def change
    add_reference :folders, :course
  end
end
