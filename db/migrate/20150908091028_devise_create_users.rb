class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |t|
      t.string :name, index: true, unique: true
      t.integer :balance, null: false, default: 0, index: true
      t.boolean :penning, null: false, default: false

      t.timestamps null: false
    end
  end
end
