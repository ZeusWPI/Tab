# == Schema Information
#
# Table name: bank_transfer_requests
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  amount_in_cents :integer          not null
#  status          :string           default("pending"), not null
#  decline_reason  :string
#  payment_code    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :bank_transfer_request do
    user { nil }
    amount { 1 }
    status { "" }
    decline_reason { "MyString" }
  end
end
