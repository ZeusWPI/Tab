# frozen_string_literal: true

module TransactionsHelper
	def amount(amount)
		amount.zero? ? nil : number_with_precision(amount / 100.0, precision: 2)
	end
end
