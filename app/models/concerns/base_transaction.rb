module BaseTransaction
  extend ActiveSupport::Concern
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  included do
    belongs_to :debtor,   class_name: 'User'
    belongs_to :creditor, class_name: 'User'
    belongs_to :issuer,   polymorphic: true

    validates :amount, numericality: { greater_than: 0 }
    validate :different_debtor_creditor
  end

  def info
    attributes.symbolize_keys.extract!(
      :debtor_id, :creditor_id, :issuer_id, :issuer_type, :message, :amount
    )
  end

  def amount_f
    euro_from_cents amount
  end

  private

  def different_debtor_creditor
    if self.debtor == self.creditor
      self.errors.add :base, "Can't write money to yourself"
    end
  end
end
