class DeletePassword < ActiveRecord::Migration
  def change
  	remove_column :users, :hashed_password
  end
end
