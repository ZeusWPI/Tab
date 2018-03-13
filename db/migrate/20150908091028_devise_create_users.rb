class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :username, index: true, unique: true

      t.integer :balance, null: false, default: 0, index: true

      t.string :name, null: false
      t.boolean :debt_allowed, null: false, default: false
      t.boolean :penning, null: false, default: false

      t.timestamps null: false
    end
  end
end
