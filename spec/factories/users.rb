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
    name { Faker::Internet.username(separators: %w[_ -]) }

    factory :penning do
      penning { true }
    end

    factory :positive_user do
      after(:create) do |user, _|
        create(:transaction, creditor: user, debtor: create(:penning), amount: 2000)
      end
    end

    trait :with_api_key do
      after(:build) do |u| # rubocop:disable Style/SymbolProc
        u.generate_key!
      end
    end
  end
end
