# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  balance    :integer          default(0), not null
#  penning    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key        :string
#

describe User, type: :model do
  before :each do
    @user = create :user
  end

  it "has a valid factory" do
    expect(@user).to be_valid
  end

  it "has a unique name" do
    user = build :user, name: @user.name
    expect(user).to_not be_valid
  end
end
