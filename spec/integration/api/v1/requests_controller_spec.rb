# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "api/v1/requests" do
  # Our user we use in most places.
  let(:user) { create(:positive_user, :with_api_key) }
  # Create a request where the user should pay.
  let!(:debtor) { create(:request, debtor: user) }
  # Create a request where the user wants money.
  let!(:creditor) { create(:request, creditor: user) }
  # Create a request issued by the user, but not to itself.
  # Note that this is probably not supported by the application
  # logic, as you would expect the debtor or the creditor to be
  # the issuing user as well.
  # This could be used in the future if some other client than
  # a user can issue requests (e.g. Haldis), but this is not
  # the case at the moment.
  let!(:issuer) { create(:request, issuer: user, status: :confirmed) }

  before do
    # An unrelated request
    create(:request)
  end

  path "/api/v1/users/{name}/requests" do
    parameter name: "name", in: :path, type: :string, description: "name"
    parameter name: "state",
              in: :query,
              type: :string,
              enum: %w[open confirmed declined cancelled],
              description: "status to filter on, must be a valid status",
              required: false

    get("get requests") do
      tags "Requests"
      security [bearer_auth: []]
      description <<~DESCR
        Returns a list of your requests, optionally filtered by status.
      DESCR

      response 200, "successful" do
        let(:api_user) { user }
        let(:name) { api_user.name }

        describe "returns all requests when not filtering" do
          run_and_add_example do |response|
            response_ids = JSON.parse!(response.body).pluck("id").to_a
            expect(response_ids).to contain_exactly(debtor.id, creditor.id, issuer.id)
          end
        end

        describe "returns confirmed requests when filtering" do
          let(:state) { "confirmed" }

          run_and_add_example do |response|
            response_ids = JSON.parse!(response.body).pluck("id").to_a
            expect(response_ids).to contain_exactly(issuer.id)
          end
        end
      end
    end
  end

  path "/api/v1/requests/{request_id}/confirm" do
    post("confirm a request") do
      tags "Requests"
      security [bearer_auth: []]
      description <<~DESCR
        Confirms a request.

        Confirming a request means executing it; money will change hands. You must
        be allowed to confirm a request, meaning you should be the debtor and you
        should have enough money, which often means enough to not go in under zero
        after the request has been accepted.
      DESCR

      parameter name: :request_id, in: :path, type: :integer

      response 204, "no content" do
        describe "can be confirmed by the debtor" do
          let(:api_user) { user }
          let(:request_id) { debtor.id }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("confirmed")

            expect(debtor_balance - debtor.amount).to eq(debtor.debtor.balance)
            expect(creditor_balance + debtor.amount).to eq(debtor.creditor.balance)
          end
        end
      end

      response 403, "denied" do
        let(:request_id) { debtor.id }

        describe "can not be accepted by the creditor" do
          let(:api_user) { debtor.creditor }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("open")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end

        describe "can not be accepted by the issuer" do
          let(:api_user) { debtor.issuer }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("open")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end
      end
    end
  end

  path "/api/v1/requests/{request_id}/cancel" do
    post("cancel a request") do
      tags "Requests"
      security [bearer_auth: []]
      description <<~DESCR
        Cancel a request.

        The issuer of a request can cancel it, meaning it will no longer be
        acceptable to the debtor.
      DESCR

      parameter name: :request_id, in: :path, type: :integer

      response 204, "no content" do
        describe "can be cancelled by the issuer" do
          let(:api_user) { debtor.issuer }
          let(:request_id) { debtor.id }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("cancelled")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end
      end

      response 403, "denied" do
        let(:request_id) { debtor.id }

        describe "can not be cancelled by the creditor" do
          let(:api_user) { debtor.creditor }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("open")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end

        describe "can not be cancelled by the debtor" do
          let(:api_user) { debtor.debtor }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("open")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end
      end
    end
  end

  path "/api/v1/requests/{request_id}/decline" do
    post("decline a request") do
      tags "Requests"
      security [bearer_auth: []]
      description <<~DESCR
        Declines a request.

        The debtor can decide to decline a request.
      DESCR

      parameter name: :request_id, in: :path, type: :integer

      response 204, "no content" do
        describe "can be declined by the debtor" do
          let(:api_user) { user }
          let(:request_id) { debtor.id }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("declined")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end
      end

      response 403, "denied" do
        let(:request_id) { debtor.id }

        describe "can not be declined by the creditor" do
          let(:api_user) { debtor.creditor }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("open")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end

        describe "can not be decline by the issuer" do
          let(:api_user) { debtor.issuer }

          add_authorization

          run_test! do
            # Save old values
            debtor_balance = debtor.debtor.balance
            creditor_balance = debtor.creditor.balance

            # Reload.
            debtor.reload

            expect(debtor.status).to eq("open")

            expect(debtor_balance).to eq(debtor.debtor.balance)
            expect(creditor_balance).to eq(debtor.creditor.balance)
          end
        end
      end
    end
  end
end
