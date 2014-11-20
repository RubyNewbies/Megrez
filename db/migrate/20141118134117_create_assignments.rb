class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :course_id
      t.string :title
      t.text :description
      t.datetime :due_to

      t.timestamps
    end
  end
end
