# frozen_string_literal: true

# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  issuer_id   :integer          not null
#  issuer_type :string           not null
#  amount      :integer          default(0), not null
#  message     :string
#  status      :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
	factory :request do
		status { :open }
		association :issuer, factory: :user, name: "Issuer"
		association :debtor, factory: :positive_user, name: "Debtor"
		association :creditor, factory: :user, name: "Creditor"
		amount { 5 }
	end
end
