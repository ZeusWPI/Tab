class DropRpushAppsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :rpush_apps
  end
end
