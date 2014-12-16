class AddTargetUrlToNotifications < ActiveRecord::Migration
  def change
    add_column  :notifications, :target_url, :string
  end
end
