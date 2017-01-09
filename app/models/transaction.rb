# == Schema Information
#
# Table name: transactions
#
#  id           :integer          not null, primary key
#  debtor_id    :integer          not null
#  creditor_id  :integer          not null
#  issuer_id    :integer          not null
#  issuer_type  :string           not null
#  amount       :integer          default(0), not null
#  message      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  id_at_client :integer
#

class Transaction < ActiveRecord::Base
  belongs_to :debtor, class_name: 'User'
  belongs_to :creditor, class_name: 'User'
  belongs_to :issuer, polymorphic: true

  after_save    :recalculate_balances
  after_destroy :recalculate_balances

  validates :amount, numericality: { greater_than: 0 }
  validates :id_at_client, presence: true, uniqueness: { scope: :issuer_id }, if: :is_client_transaction?
  validate :different_debtor_creditor


  def peer_of(user)
    return creditor if user == debtor
    return debtor if user == creditor
  end

  def signed_amount_for(user)
    return -amount if user == debtor
    return amount if user == creditor
  end

  def reverse
    self.creditor, self.debtor = self.debtor, self.creditor
    self.amount *= -1
  end

  def info
    attributes.symbolize_keys.extract!(:debtor_id, :creditor_id, :issuer_id, :issuer_type, :message, :amount)
  end

  private

  def recalculate_balances
    creditor.calculate_balance!
    debtor.calculate_balance!
  end

  def different_debtor_creditor
    if self.debtor == self.creditor
      self.errors.add :base, "Can't write money to yourself"
    end
  end

  def is_client_transaction?
    issuer_type == "Client"
  end
end
