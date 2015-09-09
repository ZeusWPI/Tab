class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :debtor, index: true, null: false
      t.references :creditor, index: true, null: false
      t.references :issuer, polymorphic: true, index: true, null: false
      t.integer :amount, null: false, default: 0
      t.string :message

      t.timestamps null: false
    end

    add_foreign_key :transactions, :users, column: :creditor_id
    add_foreign_key :transactions, :users, column: :debtor_id
  end
end
