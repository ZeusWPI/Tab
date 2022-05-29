# frozen_string_literal: true
require "rails_helper"

RSpec.describe Api::V1::TransactionsController, type: :request do
  describe "api" do

    let(:debtor) { create :user }
    let(:creditor) { create :user }
    let(:api_attributes) {
      {
        debtor: debtor.name,
        creditor: creditor.name,
        message: Faker::Lorem.sentence,
        euros: 1,
        cents: 25,
        id_at_client: 1
      }
    }
    let(:client) { create :client, name: 'Tap' }
    let(:key) { client.key }

    def post_transaction(extra_attributes = {})
      post(
        '/transactions',
        params: { transaction: api_attributes.merge(extra_attributes) },
        headers: { 'HTTP_ACCEPT' => "application/json", "HTTP_AUTHORIZATION" => "Token token=#{key}" }
      )
    end

    describe 'with key' do
      before do
        client.add_role(:create_transactions)
      end

      describe "Authentication" do
        it "should require a client authentication key" do
          post '/transactions'
          expect(response.status).to eq(302)
        end

        it "should work with valid key" do
          post_transaction
          expect(response.status).to eq(201)
        end
      end

      describe "successful creating transaction" do
        it "should create a transaction" do
          expect { post_transaction }.to change { Transaction.count }.by(1)
        end

        it "should handles floats properly" do
          expect { post_transaction(euros: 9.70, cents: 0) }.to change { Transaction.count }.by(1)

          transaction = Transaction.last

          expect(transaction.amount).to eq(970)
        end

        it "should set issuer" do
          post_transaction

          transaction = Transaction.last
          expect(transaction.issuer).to eq(client)
        end
      end

      describe "failed creating transaction" do
        # it "should create a transaction" do
        # expect { post_transaction(euros: -5) }.to change { Transaction.count }.by(0)
        # end

        # it "should give 422 status" do
        # post_transaction(euros: -4)
        # expect(last_response.status).to eq(422)
        # end
      end
    end

    describe 'without key' do
      it "should not create a transaction" do
        expect { post_transaction }.not_to(change { Transaction.count })
      end
    end
  end
end
