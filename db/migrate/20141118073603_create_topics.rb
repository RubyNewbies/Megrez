class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.integer :user_id
      t.integer :replies_count
      t.datetime :replied_at
      t.text :source
      t.text :body
      t.integer :node_id

      t.timestamps
    end
  end
end
