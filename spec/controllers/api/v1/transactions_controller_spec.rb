# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::TransactionsController, type: :request do
  describe "api" do
    let(:debtor) { create :user }
    let(:creditor) { create :user }
    let(:api_attributes) do
      {
        debtor: debtor.name,
        creditor: creditor.name,
        message: Faker::Lorem.sentence,
        euros: 1,
        cents: 25,
        id_at_client: 1
      }
    end
    let(:client) { create :client, name: "Tap" }
    let(:key) { client.key }

    def post_transaction(extra_attributes = {})
      post(
        "/api/v1/transactions",
        params: { transaction: api_attributes.merge(extra_attributes) },
        headers: { "HTTP_ACCEPT" => "application/json", "HTTP_AUTHORIZATION" => "Token token=#{key}" }
      )
    end

    describe "with key" do
      before do
        client.add_role(:create_transactions)
      end

      describe "Authentication" do
        it "requires a client authentication key" do
          post "/transactions"
          expect(response.status).to eq(302)
        end

        it "works with valid key" do
          post_transaction
          expect(response.status).to eq(201)
        end
      end

      describe "successful creating transaction" do
        it "creates a transaction" do
          expect { post_transaction }.to change(Transaction, :count).by(1)
        end

        it "handles floats properly" do
          expect { post_transaction(euros: 9.70, cents: 0) }.to change(Transaction, :count).by(1)

          transaction = Transaction.last

          expect(transaction.amount).to eq(970)
        end

        it "sets issuer" do
          post_transaction

          transaction = Transaction.last
          expect(transaction.issuer).to eq(client)
        end
      end
    end

    describe "without key" do
      it "does not create a transaction" do
        expect { post_transaction }.not_to(change(Transaction, :count))
      end
    end
  end
end
