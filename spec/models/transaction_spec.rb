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

require 'rails_helper'

RSpec.describe Transaction, type: :model do
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

end
