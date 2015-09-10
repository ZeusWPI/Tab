# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  issuer_id   :integer          not null
#  issuer_type :string           not null
#  amount      :integer          default(0), not null
#  message     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :transaction do
    association :debtor, factory: :user
    association :creditor, factory: :user
    issuer { debtor }
    amount { 1 + rand(100) }
    message { Faker::Lorem.sentence }
  end
end
