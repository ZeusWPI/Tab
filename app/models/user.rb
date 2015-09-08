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
  devise :timeoutable, :omniauthable, :omniauth_providers => [:zeuswpi]
  has_many :incoming_transactions,
    class_name: 'Transaction', foreign_key: 'creditor_id'
  has_many :outgoing_transactions,
    class_name: 'Transaction', foreign_key: 'debtor_id'

  validates :name, presence: true, uniqueness: true
  validates :balance, presence: true

  def transactions
    Transaction.where("creditor_id = ? OR debtor_id = ?", id, id)
  end

  def calculate_balance!
    balance = incoming_transactions.sum(:amount) -
                outgoing_transactions.sum(:amount)
    self.update_attribute :balance, balance
  end

  def self.from_omniauth(auth)
    where(name: auth.uid).first_or_create do |user|
      user.name = auth.uid
    end
  end
end
