class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :debtor,   index: true,       null: false
      t.references :creditor, index: true,       null: false
      t.references :issuer,   polymorphic: true, index: true, null: false
      t.integer :amount, null: false, default: 0
      t.string :message

      t.integer :status, default: 0

      t.timestamps null: false
    end

    add_foreign_key :request, :users, column: :creditor_id
    add_foreign_key :request, :users, column: :debtor_id
  end
end
