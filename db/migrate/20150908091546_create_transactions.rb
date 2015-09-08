class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :debtor, index: true, foreign_key: true, null: false
      t.references :creditor, index: true, foreign_key: true, null: false
      t.integer :amount, null: false, default: 0
      t.string :origin, null: false
      t.string :message

      t.timestamps null: false
    end
  end
end
