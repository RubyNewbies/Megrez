class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :weight
      t.integer :father_id
      t.integer :course_id
      t.integer :child_count

      t.timestamps
    end
  end
end
