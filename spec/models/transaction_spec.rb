# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  debtor_id   :integer          not null
#  creditor_id :integer          not null
#  issuer_id   :integer          not null
#  issuer_type :string           not null
#  amount      :integer          default(0), not null
#  message     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

describe Transaction, type: :model do
  it "has a valid factory" do
    expect(create(:transaction)).to be_valid
  end

  describe "cache" do
    before :each do
      @user = create(:user)
    end

    it "should update creditor cache" do
      trans = build(:transaction, creditor: @user, amount: 10)
      expect {trans.save!}.to change {@user.balance}.by(10)
    end

    it "should update debtor cache" do
      trans = build(:transaction, debtor: @user, amount: 10)
      expect {trans.save!}.to change {@user.balance}.by(-10)
    end
  end

  describe "amount" do
    it "should be positive" do
      expect(build :transaction, amount: -5).to_not be_valid
    end

    it "should not be 0" do
      expect(build :transaction, amount: 0).to_not be_valid
    end
  end

  describe "debtor/creditor" do
    it "should be different" do
      @user = create :user
      expect(build :transaction, debtor: @user, creditor: @user).to_not be_valid
    end
  end
end
