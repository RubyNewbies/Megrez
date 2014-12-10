class CreateAssignfiles < ActiveRecord::Migration
  def change
    create_table :assignfiles do |t|
      t.integer :assignment_id
      t.integer :user_id
      t.string :source

      t.timestamps
    end
  end
end
