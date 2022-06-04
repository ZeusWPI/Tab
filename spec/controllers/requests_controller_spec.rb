# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestsController, type: :controller do
  describe "accepting request" do
    let(:request) { create(:request, amount: 10) }

    context "when accepting a request" do
      it "can be accepted by the debtor" do
        debtor_balance = request.debtor.balance
        creditor_balance = request.creditor.balance

        sign_in request.debtor
        post :confirm, params: { request_id: request.id }

        request.reload

        expect(request.status).to eq("confirmed")

        expect(debtor_balance - 10).to eq(request.debtor.balance)
        expect(creditor_balance + 10).to eq(request.creditor.balance)
      end

      it "can not be accepted by the creditor" do
        debtor_balance = request.debtor.balance
        creditor_balance = request.creditor.balance

        sign_in request.creditor
        post :confirm, params: { request_id: request.id }

        request.reload

        expect(request.status).to eq("open")

        expect(debtor_balance).to eq(request.debtor.balance)
        expect(creditor_balance).to eq(request.creditor.balance)
      end

      it "can not be accepted by the issuer" do
        debtor_balance = request.debtor.balance
        creditor_balance = request.creditor.balance

        sign_in request.issuer
        post :confirm, params: { request_id: request.id }

        request.reload

        expect(request.status).to eq("open")

        expect(debtor_balance).to eq(request.debtor.balance)
        expect(creditor_balance).to eq(request.creditor.balance)
      end
    end
  end
end
