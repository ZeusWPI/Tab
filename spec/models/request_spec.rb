# == Schema Information
#
# Table name: requests
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  issuer_type :string           not null
#  issuer_id   :integer          not null
#  amount      :integer          default(0), not null
#  message     :string
#  status      :integer          default("open")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Request, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
