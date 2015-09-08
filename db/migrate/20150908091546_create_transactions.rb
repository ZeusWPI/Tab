class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :debtor, index: true, foreign_key: true
      t.references :creditor, index: true, foreign_key: true
      t.integer :amount
      t.string :origin
      t.string :message

      t.timestamps null: false
    end
  end
end
