class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :receiver
      t.integer :sender
      t.text :content

      t.timestamps
    end
  end
end
