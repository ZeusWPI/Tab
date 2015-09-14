class AddIdAtClientToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :id_at_client, :int
    add_index :transactions, [:issuer_id, :id_at_client]
  end
end
