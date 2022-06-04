# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransactionsController, type: :controller do
  describe "creating transaction" do
    let(:debtor) { create(:positive_user) }
    let(:creditor) { create(:user) }

    before do
      sign_in debtor
    end

    context "with valid attributes" do
      let(:attributes) do
        {
          transaction: {
            debtor: debtor.name,
            creditor: creditor.name,
            cents: 70,
            message: "hoi"
          }
        }
      end

      it "creates a new transaction" do
        expect { post(:create, params: attributes) }.to change(Transaction, :count).by(1)
      end

      describe "fields" do
        let(:transaction) { Transaction.last }

        before do
          post(:create, params: attributes)
        end

        it "sets debtor" do
          expect(transaction.debtor).to eq(debtor)
        end

        it "sets amount" do
          expect(transaction.amount).to eq(70)
        end

        it "sets creditor" do
          expect(transaction.creditor).to eq(creditor)
        end

        it "sets issuer" do
          expect(transaction.issuer).to eq(debtor)
        end
      end
    end

    context "with float euros" do
      it "sets correct amount" do
        post(:create, params: {
               transaction: {
                 debtor: debtor.name,
                 creditor: creditor.name,
                 euros: 10.5,
                 message: "Omdat je een leuke jongen bent!"
               }
             })
        expect(Transaction.last.amount).to eq(1050)
      end
    end

    context "with negative amount" do
      it "is refused" do
        expect do
          post(:create, params: { transaction: attributes_for(:transaction, cents: -20) })
        end.not_to(change(Transaction, :count))
      end
    end

    context "with way to much money" do
      it "is refused" do
        expect do
          post(:create, params: {
                 transaction: {
                   debtor: debtor.name,
                   creditor: creditor.name,
                   euros: 100_000_000_000_000,
                   message: "VEEL GELD"
                 }
               })
        end.not_to(change(Transaction, :count))
      end
    end

    context "when for other user" do
      it "is refused" do
        expect do
          post(:create, params: {
                 transaction: {
                   debtor: creditor.name,
                   creditor: debtor.name,
                   euros: 10,
                   message: "DIT IS OVERVAL"
                 }
               })
        end.not_to(change(Transaction, :count))
      end
    end

    context "when resulting in negative balance" do
      it "is refused" do
        expect do
          post(:create, params: {
                 transaction: {
                   debtor: create(:user).name,
                   creditor: creditor.name,
                   euros: 1,
                   message: "Debts"
                 }
               })
        end.not_to(change(Transaction, :count))
      end
    end
  end
end
