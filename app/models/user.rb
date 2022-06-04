# frozen_string_literal: true

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

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :finders

  devise :timeoutable, :omniauthable, omniauth_providers: %i[zeuswpi]

  has_many :incoming_transactions,
           class_name: "Transaction", foreign_key: "creditor_id"
  has_many :outgoing_transactions,
           class_name: "Transaction", foreign_key: "debtor_id"
  has_many :incoming_requests,
           class_name: "Request", foreign_key: "debtor_id"
  has_many :outgoing_requests,
           class_name: "Request", foreign_key: "creditor_id"
  has_many :notifications
  has_many :android_device_registration_tokens, class_name: "AndroidDeviceRegistrationToken", foreign_key: "user_id"

  has_many :issued_transactions, as: :issuer, class_name: "Transaction"

  validates :name, presence: true, uniqueness: true

  scope :humans, -> { where.not(id: zeus) }

  def transactions
    Transaction.where(creditor_id: id).or(Transaction.where(debtor_id: id))
  end

  def requests
    Request.where(debtor_id: id).or(Request.where(creditor_id: id).or(Request.where(issuer_id: id)))
  end

  def calculate_balance!
    balance = incoming_transactions.sum(:amount) - outgoing_transactions.sum(:amount)
    self.update_attribute(:balance, balance) # rubocop:disable Rails/SkipsModelValidations
  end

  def self.from_omniauth(auth)
    find_or_create_by!(name: auth.uid) do |user| # rubocop:disable Style/SymbolProc
      user.generate_key!
    end
  end

  def self.zeus
    @@zeus ||= find_or_create_by!(name: "Zeus")
  end

  def generate_key
    set_key unless self.key
  end

  def generate_key!
    set_key
    self.save
  end

  private

  def set_key
    self.key = SecureRandom.base64(16)
  end
end
