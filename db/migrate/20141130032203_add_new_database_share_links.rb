class AddNewDatabaseShareLinks < ActiveRecord::Migration
  def change
  	create_table "share_links" do |t|
    t.string   "emails"
    t.string   "link_token"
    t.datetime "link_expires_at"
    t.integer  "user_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.integer  "user_id"
  end
  end
end
