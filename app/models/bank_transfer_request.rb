# == Schema Information
#
# Table name: bank_transfer_requests
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  amount_in_cents :integer          not null
#  status          :integer          default("pending"), not null
#  decline_reason  :string
#  payment_code    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class BankTransferRequest < ApplicationRecord
  belongs_to :user, required: true

  enum status: [:pending, :approved, :declined, :cancelled]

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
