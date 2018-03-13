# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  balance    :integer          default(0), not null
#  penning    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, use: :finders
  devise :cas_authenticatable
  has_many :incoming_transactions,
    class_name: 'Transaction', foreign_key: 'creditor_id'
  has_many :outgoing_transactions,
    class_name: 'Transaction', foreign_key: 'debtor_id'
  has_many :incoming_requests,
    class_name: 'Request', foreign_key: 'debtor_id'
  has_many :outgoing_requests,
    class_name: 'Request', foreign_key: 'creditor_id'
  has_many :notifications

  has_many :issued_transactions, as: :issuer, class_name: 'Transaction'

  validates :name, presence: true, uniqueness: true

  scope :humans, -> { where.not(id: self.wina) }

  def transactions
    Transaction.where("creditor_id = ? OR debtor_id = ?", id, id)
  end

  def calculate_balance!
    balance = incoming_transactions.sum(:amount) -
                outgoing_transactions.sum(:amount)
    self.update_attribute :balance, balance
  end

  def cas_extra_attributes=(extra_attributes)
    self.name = extra_attributes['display_name']
    self.debt_allowed = extra_attributes['permissions'].include? 'HAVE_SCHULDEN'
    self.penning = extra_attributes['permissions'].include? 'MANAGE_SCHULDEN'
  end

  def self.wina
    @@wina ||= find_or_create_by name: 'WiNA', username: :WiNA
  end
end
