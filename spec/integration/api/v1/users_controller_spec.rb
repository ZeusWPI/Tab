# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "api/v1/users" do
  let(:api_user) { create(:penning, :with_api_key) }

  path "/api/v1/users" do
    get("list users") do
      tags "Users"
      security [bearer_auth: []]
      description <<~DESCR
        Returns a list of users accessible to you.

        **Not all fields are available to all users:** penning has access to most fields, while regular
        users can only see ids and names.
      DESCR

      response(200, "successful") do
        run_and_add_example

        context "when api user is regular user" do
          let(:api_user) { create(:user, :with_api_key) }
          let(:other_user) { create(:user) }
          let(:name) { other_user.name }

          it "does not contain user balance" do
            expect(JSON.parse(response.body).first).not_to include("balance")
          end
        end

        context "when user is penning" do
          it "does not contain user api key" do
            expect(JSON.parse(response.body).first).not_to include("key")
          end

          it "contains user balance" do
            expect(JSON.parse(response.body).first).to include("balance")
          end
        end
      end

      response(401, "not authorized") do
        let(:api_user) { create(:user) }

        run_and_add_example
      end
    end
  end

  path "/api/v1/users/{name}" do
    parameter name: "name", in: :path, type: :string, description: "name"

    get("show user") do
      tags "Users"
      security [bearer_auth: []]
      description <<~DESCR
        Returns a specific users information accessible to you.

        **Not all fields are available to all users:** penning has access to most fields, while regular
        users can only see ids and names.
      DESCR

      response(200, "successful") do
        let(:user) { create(:user) }
        let(:name) { user.name }

        run_and_add_example

        context "when api user is regular user" do
          let(:api_user) { create(:user, :with_api_key) }

          it "does not contain user balance" do
            expect(JSON.parse(response.body)).not_to include("balance")
          end
        end

        context "when api user is penning" do
          let(:api_user) { create(:penning, :with_api_key) }

          it "does not contain user api key" do
            expect(JSON.parse(response.body)).not_to include("key")
          end

          it "contains user balance" do
            expect(JSON.parse(response.body)).to include("balance")
          end
        end
      end

      response(401, "not authorized") do
        let(:name) { "random" }
        let(:api_user) { create(:user) }

        run_and_add_example
      end

      response(404, "user not found") do
        let(:name) { "random" }

        run_and_add_example
      end
    end
  end
end
