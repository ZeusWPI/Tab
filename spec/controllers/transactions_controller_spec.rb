require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe "creating transaction" do
    before :each do
      @debtor = create(:user)
      @creditor = create(:user)
      sign_in @debtor
    end

    it "should create a valid transaction" do
      expect do
        put :create, { transaction: {
          creditor: @creditor.name,
          amount: 20,
          message: "hoi"
        }}
      end.to change {Transaction.count}.by(1)
    end
  end
end
