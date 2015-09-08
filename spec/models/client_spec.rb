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

require 'rails_helper'

RSpec.describe Client, type: :model do
  it "should have a valid factory" do
    expect(create(:client)).to be_valid
  end

  it "should generate a key" do
    expect(create(:client).key).to be_present
  end
end
