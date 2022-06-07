# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "api/v1/transactions", type: :request do
  let(:api_user) { create(:penning, :with_api_key) }

  let(:debtor) { create :user }
  let(:creditor) { create :user }
  let(:transaction_params) do
    {
      debtor: debtor.name,
      creditor: creditor.name,
      message: Faker::Lorem.sentence,
      euros: 1,
      cents: 25,
      id_at_client: 1
    }
  end

  path "/api/v1/users/{name}/transactions" do
    parameter name: "name", in: :path, type: :string, description: "name"

    get("get transactions") do
      tags "Transactions"
      security [bearer_auth: []]
      description <<~DESCR
        Returns a list of your transactions.
      DESCR

      response(200, "successful") do
        let(:name) { api_user.name }

        run_and_add_example
      end
    end
  end

  path "/api/v1/transactions" do
    post("create transaction") do
      tags "Transactions"
      security [bearer_auth: []]
      description <<~DESCR
        Creates a new transaction.

        When the amount is negative, the transaction will be automatically converted into a request.
        Unless you're penning, then it will just get the money without creating a request.

        All parameters are optional with the following constraints and defaults:
           * When leaving the `debtor` or `creditor` empty, this will default to the Zeus user.
           * At least one of `euros` and `cents` needs to be filled in
           * When creating a transaction as client, the `id_at_client` is mandatory
      DESCR

      consumes "application/json"
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction: {
            type: :object,
            properties: {
              debtor: {
                type: :string,
                nullable: true,
                description: "Defaults to Zeus when empty"
              },
              creditor: {
                type: :string,
                nullable: true,
                description: "Defaults to Zeus when empty"
              },
              message: { type: :string, nullable: true },
              euros: {
                type: :integer,
                nullable: true,
                description: "Required when `cents` empty"
              },
              cents: {
                type: :integer,
                nullable: true,
                description: "Required when `euros` empty"
              },
              id_at_client: {
                type: :string,
                nullable: true,
                description: "Required when creating a transaction as client, unique per client"
              },
            }
          }
        },
        required: ["transaction"]
      }

      response(201, "successful") do
        let(:transaction) do
          { transaction: transaction_params }
        end

        run_and_add_example

        context "when sending floats as euros" do
          let(:transaction) do
            { transaction: transaction_params.merge(euros: 9.70, cents: 0) }
          end

          it "handles floats properly" do
            transaction = Transaction.last

            expect(transaction.amount).to eq(970)
          end
        end

        context "when creating a transaction" do
          let(:transaction) do
            { transaction: transaction_params }
          end

          it "sets issuer" do
            transaction = Transaction.last
            expect(transaction.issuer).to eq(api_user)
          end
        end
      end

      response(401, "not authorized") do
        let(:api_user) { create(:user) }
        let(:transaction) do
          { transaction: transaction_params }
        end

        run_and_add_example
      end
    end
  end
end
