class AddRefCount < ActiveRecord::Migration
  def change
    add_column :user_files, :reference_count, :integer
  end
end
