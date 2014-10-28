class CreateCourseUserRelationships < ActiveRecord::Migration
  def change
    create_table :course_user_relationships do |t|
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end

    add_index :course_user_relationships, :user_id
    add_index :course_user_relationships, :course_id
    add_index :course_user_relationships, [:user_id, :course_id], unique: true

  end
end
