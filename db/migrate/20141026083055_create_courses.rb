class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :department_id
      t.string :full_name
      t.string :english_name
      t.string :description
      t.string :key

      t.timestamps
    end
  end
end
