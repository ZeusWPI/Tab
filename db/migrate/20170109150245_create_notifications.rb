class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, index: true, null: false
      t.string :message
      t.boolean :read,    default: false

      t.timestamps null: false
    end
  end
end
