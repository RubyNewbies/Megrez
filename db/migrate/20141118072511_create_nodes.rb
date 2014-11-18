class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.string :icon
      t.integer :father_id
      t.integer :course_id
      t.integer :child_count

      t.timestamps
    end
  end
end
