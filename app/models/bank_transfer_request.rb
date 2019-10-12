# == Schema Information
#
# Table name: bank_transfer_requests
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  amount_in_cents :integer          not null
#  status          :string           default("pending"), not null
#  decline_reason  :string
#  payment_code    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class BankTransferRequest < ApplicationRecord
  belongs_to :user, required: true

  enum status: {
    pending: "pending",
    approved: "approved",
    declined: "declined",
    cancelled: "cancelled"
  }

  validates :amount_in_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :payment_code, presence: true, uniqueness: true

  PAYMENT_CODE_PREFIX = "TAB"

  def set_payment_code
    self.payment_code = self.class.generate_payment_code
  end

  def amount
    from_cents read_attribute(:amount_in_cents)
  end

  def amount=(value)
    write_attribute(:amount_in_cents, to_cents(value))
  end

  def approve!
    if self.declined?
      message = "Declined bank transfer request ##{self.id} with code #{self.payment_code} has been reversed and is now accepted."
    else
      message = "Bank transfer request ##{self.id} with code #{self.payment_code} has been approved."
    end
    Transaction.create!(
      debtor: User.zeus,
      creditor: self.user,
      issuer: User.zeus,
      amount: self.amount_in_cents,
      message: message
    )
    Notification.create user: self.user, message: message

    self.approved!
  end

  def decline!(reason=nil)
    self.decline_reason = reason
    if self.approved?
      # Transaction needs to be reversed
      message = "Approved bank transfer request ##{self.id} with code #{self.payment_code} has been reversed and is now declined."

      Transaction.create!(
        debtor: self.user,
        creditor: User.zeus,
        issuer: User.zeus,
        amount: self.amount_in_cents,
        message: message
      )
    else
      message = "Bank transfer request ##{self.id} with code #{self.payment_code} has been declined."
    end

    Notification.create user: self.user, message: message

    self.declined!
  end

  def cancel!
    self.cancelled!
  end

  def approvable?
    self.pending? || self.declined?
  end

  def declinable?
    self.pending? || self.approved?
  end

  def cancellable?
    self.pending?
  end


  def self.generate_payment_code
    random = rand(10**15)
    return sprintf("#{PAYMENT_CODE_PREFIX}%02d%015d", random % 97, random)
  end

  def self.find_payment_code_from_csv(csvline)
    match = /#{PAYMENT_CODE_PREFIX}\d+/.match(csvline)
    if match
      return self.find_by_payment_code(match[0])
    else
      return false
    end
  end

  private

  def from_cents(value)
    (value || 0) / 100.0
  end

  def to_cents(value)
    if value.is_a? String then value.sub!(',', '.') end
    (value.to_f * 100).to_int
  end

end
