class AddNewDatabase < ActiveRecord::Migration
  def change
  	add_column	:users,	:hashed_password,  :string
  	add_column  :users, :is_admin, :boolean
  	add_column	:users,	:reset_password_token,  :string
  	add_column	:users,	:reset_password_token_expires_at,  :datetime
  	add_column	:users,	:signup_token,  :string
  	add_column	:users,	:signup_token_expires_at,  :string
  end
end
