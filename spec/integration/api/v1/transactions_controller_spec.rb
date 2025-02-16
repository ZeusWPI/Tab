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
      cents: 250,
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
            # Create some extra transactions, note that there are already 2 in the spec
            5.times { |i| create(:transaction, creditor: api_user, message: "transaction #{i}") }
          end

          describe "returns last 5 transactions" do
            let(:limit) { 5 }

            run_and_add_example do |response|
              transactions = JSON.parse(response.body)
              expect(transactions.length).to eq(5)
              expect(transactions.first).to include("message" => "transaction 4")
            end
          end

          describe "skips 1 transaction and returns 3" do
            let(:limit) { 3 }
            let(:start) { 1 }

            run_and_add_example do |response|
              transactions = JSON.parse(response.body)
              expect(transactions.length).to eq(3)
              expect(transactions.first).to include("message" => "transaction 3")
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
           * `cents` must be an integer, or a string representation of one, never a float (or string float).
           * When creating a transaction as client, the `id_at_client` is mandatory.
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
              cents: {
                type: :integer,
                nullable: false,
                description: "Amount in cents"
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

        context "when cents is a string" do
          run_and_add_example

          let(:transaction) do
            { transaction: transaction_params.merge(cents: "150") }
          end

          it "creates a transaction" do
            transaction = Transaction.last
            expect(transaction.amount).to eq(150)
          end
        end

        context "when api user is a penning" do
          run_and_add_example

          it "creates a transaction" do
            transaction = Transaction.last

            expect(transaction.amount).to eq(250)
            expect(transaction.debtor).to eq(debtor)
            expect(transaction.creditor).to eq(creditor)
          end

          it "sets issuer" do
            transaction = Transaction.last
            expect(transaction.issuer).to eq(api_user)
          end

          context "when cents is a negative integer" do
            let(:transaction) do
              { transaction: transaction_params.merge(cents: -350) }
            end

            run_test!

            it "creates a transaction and switches debtor and creditor" do
              transaction = Transaction.last
              expect(transaction.amount).to eq(350)
              expect(transaction.debtor).to eq(creditor)
              expect(transaction.creditor).to eq(debtor)
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

            context "when cents is negative" do
              let(:transaction) do
                { transaction: transaction_params.merge(cents: -2) }
              end

              run_test!

              it "creates a transaction where the creditor becomes debtor" do
                request = Request.last
                expect(request.issuer).to eq(api_user)
                expect(request.debtor).to eq(creditor)
                expect(request.creditor).to eq(debtor)
                expect(request.amount).to eq(2)
              end
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
            { transaction: transaction_params.merge(cents: 2) }
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

      response(422, "unprocessable entity") do
        let(:transaction) do
          { transaction: transaction_params.merge(cents: 0.3) }
        end

        run_and_add_example

        context "when cents is a float" do
          it "returns an error" do
            expect(JSON.parse(response.body)).to eq(["Amount must be an integer"])
          end
        end

        context "when cents is a string float" do
          let(:transaction) do
            { transaction: transaction_params.merge(cents: "2.50") }
          end

          it "returns an error" do
            expect(JSON.parse(response.body)).to eq(["Amount must be an integer"])
          end
        end
      end
    end
  end
end
