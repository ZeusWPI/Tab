# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  amount      :integer          default(0), not null
#  origin      :string           not null
#  message     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :transaction do
    debtor
    creditor
    amount { rand(100) }
    origin 'FactoryGirl'
    message { Faker::Lorem.sentence }
  end
end
