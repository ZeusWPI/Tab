class AddUniqueIndexToClientName < ActiveRecord::Migration[7.0]
  def change
    remove_index(:clients, :name)
    add_index(:clients, :name, unique: true)
  end
end
