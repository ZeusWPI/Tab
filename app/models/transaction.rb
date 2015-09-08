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

class Transaction < ActiveRecord::Base
  belongs_to :debtor, class_name: 'User'
  belongs_to :creditor, class_name: 'User'

  def client
    Client.find_by name: origin
  end
end
