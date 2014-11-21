class AddOpenAtToAssignments < ActiveRecord::Migration
  def change

    add_column :assignments, :open_at, :datetime
  end
end
