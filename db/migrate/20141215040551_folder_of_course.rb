class FolderOfCourse < ActiveRecord::Migration
  def change
    add_column :folders, :is_doc, :boolean
    add_column :folders, :is_assignment, :boolean
    
  end
end
