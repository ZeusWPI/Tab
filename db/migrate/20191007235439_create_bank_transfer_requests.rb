class CreateBankTransferRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_transfer_requests do |t|
      t.references :user, foreign_key: true
      t.integer :amount_in_cents, null: false
      t.string :status, null: false, default: "pending"
      t.string :decline_reason
      t.string :payment_code, null: false, unique: true

      t.timestamps
    end
  end
end
