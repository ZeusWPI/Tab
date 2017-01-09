class Request < ActiveRecord::Base
  belongs_to :debtor,   class_name: 'User'
  belongs_to :creditor, class_name: 'User'
  belongs_to :issuer,   polymorphic: true

  validates :amount, numericality: { greater_than: 0 }
  validate  :different_debtor_creditor

  enum status: [:open, :confirmed, :declined]

  def confirm!
    return unless open?

    Transaction.create attributes.symbolize_keys.extract!(
      :debtor_id, :creditor_id, :issuer_id, :issuer_type, :amount, :message
    )
    update_attributes status: :confirmed
  end

  def decline!
    return unless open?

    update_attributes status: :declined
  end

  private

  def different_debtor_creditor
    if self.debtor == self.creditor
      self.errors.add :base, "Can't write money to yourself"
    end
  end
end
