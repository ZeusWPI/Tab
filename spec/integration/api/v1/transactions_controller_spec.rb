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
      parameter name: "limit",
                in: :query,
                type: :integer,
                description: "Amount of transactions fetched",
                required: false
      parameter name: "start",
                in: :query,
                type: :integer,
                description: "Amount of transactions to skip",
                required: false

      response(200, "successful") do
        let(:name) { api_user.name }

        before do
          create(:transaction, debtor: api_user)
          create(:transaction, creditor: api_user)
        end

        context "when no parameters are passed" do
          run_and_add_example

          it "returns transactions where api user is debtor" do
            expect(JSON.parse(response.body)).to include(include("debtor" => name))
          end

          it "returns transactions where api user is creditor" do
            expect(JSON.parse(response.body)).to include(include("creditor" => name))
          end
        end

        context "when a limit is added" do
          before do
            # Create some extra transactions
            5.times.each { |_i| create(:transaction, creditor: api_user) }
          end

          describe "returns last 5 transactions" do
            let(:limit) { 5 }

            run_and_add_example do |response|
              transactions = JSON.parse(response.body)
              expect(transactions.length).to eq(5)
              expect(transactions.first).to include("id" => 7)
            end
          end

          describe "skips 1 transaction and returns 3" do
            let(:limit) { 3 }
            let(:start) { 1 }

            run_and_add_example do |response|
              transactions = JSON.parse(response.body)
              expect(transactions.length).to eq(3)
              expect(transactions.first).to include("id" => 6)
            end
          end
        end
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
        Unless you're penning or you're using an api client with the `:create_transactions` role,
        then it will create a transaction.

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
                type: :integer,
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

        context "when api user is a penning" do
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
            it "sets issuer" do
              transaction = Transaction.last
              expect(transaction.issuer).to eq(api_user)
            end
          end
        end

        context "when api user is a regular user" do
          let(:api_user) { create(:user, :with_api_key, balance: 1000) }

          add_authorization

          context "when api user is debtor" do
            let(:debtor) { api_user }

            run_test!

            it "creates a transaction" do
              transaction = Transaction.last
              expect(transaction.issuer).to eq(api_user)
            end
          end

          context "when api user is creditor" do
            let(:creditor) { api_user }

            run_test!

            it "creates a request" do
              request = Request.last
              expect(request.issuer).to eq(api_user)
            end
          end
        end

        context "when api user is a client" do
          let(:api_user) { create(:client, name: "Tap") }

          add_authorization

          context "without create_transactions role" do
            run_test!

            it "creates a request" do
              request = Request.last
              expect(request.issuer).to eq(api_user)
            end
          end

          context "with create_transactions role" do
            before do
              api_user.add_role(:create_transactions)
            end

            run_test!

            it "creates a transaction" do
              transaction = Transaction.last
              expect(transaction.issuer).to eq(api_user)
            end
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

      response(403, "denied") do
        let(:api_user) { create(:user, :with_api_key) }
        let(:transaction) do
          { transaction: transaction_params }
        end

        run_and_add_example

        context "when api user is debtor with not enough credit" do
          let(:debtor) { api_user }

          let(:transaction) do
            { transaction: transaction_params.merge(euros: 0, cents: 2) }
          end

          before do
            api_user.update!(balance: 1)
          end

          run_test!
        end

        context "with different creditor" do
          let(:creditor) { create(:user) }

          run_test!
        end
      end
    end
  end
end
