class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false, index: true, unique: true
      t.string :key, null: false,  index: true, unique: true

      t.timestamps null: false
    end
  end
end
