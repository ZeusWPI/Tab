# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  key        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Client < ActiveRecord::Base
  def transactions
    Transaction.where(origin: name)
  end
end
