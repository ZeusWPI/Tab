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

class Client < ApplicationRecord
  rolify

  has_many :issued_transactions, as: :issuer, class_name: 'Transaction'

  before_create :generate_key

  validates :name, presence: true, uniqueness: true

  private

  def generate_key
    self.key = SecureRandom.base64(16) unless self.key
  end
end
