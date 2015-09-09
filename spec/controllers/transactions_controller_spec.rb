require 'rails_helper'
require 'spec_helper'

RSpec.describe TransactionsController, type: :controller do
  describe "creating transaction" do
    before :each do
      @debtor = create(:user)
      @creditor = create(:user)
      sign_in @debtor
    end

    context "with valid attributes" do
      before :each do
        @attributes = { transaction: {
          creditor: @creditor.name,
          amount: 20,
          message: 'hoi'
        }}
        post :create, @attributes
        @transaction = Transaction.last
      end

      it "should create a new transaction" do
        expect {post :create, @attributes}.to change {Transaction.count}.by(1)
      end

      it "should set debtor" do
        expect(@transaction.debtor).to eq(@debtor)
      end

      it "should set amount" do
        expect(@transaction.amount).to eq(20)
      end

      it "should set creditor" do
        expect(@transaction.creditor).to eq(@creditor)
      end

      it "should set issuer" do
        expect(@transaction.issuer).to eq(@debtor)
      end
    end

    context "with negative amount" do
      it "should be refused" do
        expect do
          post :create, transaction: attributes_for(:transaction, amount: -20)
        end.not_to change {Transaction.count}
      end
    end

    context "for other user" do
      it "should be refused" do
        expect do
          post :create, transaction: {
            debtor: @creditor,
            creditor: @debtor,
            amount: 10000000000000,
            message: 'DIT IS OVERVAL'
          }
        end.not_to change {Transaction.count}
      end
    end
  end
end
