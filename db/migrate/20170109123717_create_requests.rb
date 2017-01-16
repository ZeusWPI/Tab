class CreateRequests < ActiveRecord::Migration
  def change
    unless table_exists? :requests
      create_table :requests do |t|
        t.references :debtor,   null: false
        t.references :creditor, null: false
        t.references :issuer,   polymorphic: true, null: false
        t.integer :amount, null: false, default: 0
        t.string :message

        t.integer :status, default: 0

        t.timestamps null: false
      end
    end

    add_index :requests, :debtor_id   unless index_exists?(:requests, :debtor)
    add_index :requests, :creditor_id unless index_exists?(:requests, :creditor)
    add_index :requests, [:issuer_type, :issuer_id] unless index_exists?(:requests, :issuer)

    add_foreign_key :requests, :users, column: :creditor_id
    add_foreign_key :requests, :users, column: :debtor_id
  end
end
