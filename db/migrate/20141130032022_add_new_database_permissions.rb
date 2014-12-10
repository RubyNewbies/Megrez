class AddNewDatabasePermissions < ActiveRecord::Migration
  def change
  	create_table :permissions do |t|
      t.integer "folder_id"
      t.integer "group_id"
      t.boolean "can_create"
      t.boolean "can_read"
      t.boolean "can_update"
      t.boolean "can_delete"

      t.timestamps
  	end
  end
end
