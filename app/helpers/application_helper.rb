# frozen_string_literal: true

module ApplicationHelper
	def euro(float)
		number_to_currency float, unit: "€"
	end

	def euro_from_cents(cents)
		euro(cents / 100.0) if cents
	end

	def title(page_title)
		content_for(:title) { page_title }
	end
end
