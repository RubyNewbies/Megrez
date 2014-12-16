class AddLangToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferred_lang, :string
  end
end
