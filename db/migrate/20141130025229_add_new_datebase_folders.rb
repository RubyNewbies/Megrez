class AddNewDatebaseFolders < ActiveRecord::Migration
  def change
  	create_table :folders do |t|
      t.string   :name
      t.integer  :parent_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
  	end
  end
end