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

require 'rails_helper'

RSpec.describe BankTransferRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
