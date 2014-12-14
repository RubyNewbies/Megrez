class AddNewDatebaseFiles < ActiveRecord::Migration
  def change
  	create_table :user_files do |t|
      t.string  :attachment_file_name
      t.string  :attachment_content_type
      t.string  :attachment_fingerprint
      
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
      t.integer  :folder_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
