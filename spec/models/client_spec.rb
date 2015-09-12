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

describe Client, type: :model do
  before :each do
    @client = create :client
  end

  it "should have a valid factory" do
    expect(@client).to be_valid
  end

  it "should generate a key" do
    expect(@client.key).to be_present
  end

  it "should have a unique name" do
    client = build :client, name: @client.name
    expect(client).to_not be_valid
  end
end
