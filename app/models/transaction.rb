# frozen_string_literal: true

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

class Transaction < ApplicationRecord
	include BaseTransaction
	include TransactionHelpers

	after_destroy :recalculate_balances!
	after_save    :recalculate_balances!

	validates :id_at_client, presence: true, uniqueness: { scope: :issuer_id }, if: :client_transaction?

	def reverse
		self.creditor, self.debtor = self.debtor, self.creditor
		self.amount *= -1
	end

	private

	def recalculate_balances!
		creditor.calculate_balance!
		debtor.calculate_balance!
	end
end
