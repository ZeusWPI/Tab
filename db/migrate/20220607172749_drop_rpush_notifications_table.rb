class DropRpushNotificationsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :rpush_notifications
  end
end
