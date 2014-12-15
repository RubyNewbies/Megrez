class AddLangToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :preferred_leng
    add_column :users, :preferred_lang, :string
  end
end
