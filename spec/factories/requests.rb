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

FactoryGirl.define do
  factory :request do
    
  end

end
