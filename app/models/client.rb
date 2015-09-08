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
  before_create :generate_key

  validates :name, presence: true, uniqueness: true
  validates :key, presence: true, uniqueness: true

  def transactions
    Transaction.where(origin: name)
  end

  private
  def generate_key
    self.key = SecureRandom.base64(16) unless self.key
  end
end
