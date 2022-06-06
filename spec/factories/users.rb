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

FactoryBot.define do
	factory :user do
		name { Faker::Internet.user_name }

		factory :penning do
			penning { true }
		end

		factory :positive_user do
			after(:create) do |user, _|
				create(:transaction, creditor: user, debtor: create(:penning), amount: 2000)
			end
		end
	end
end
