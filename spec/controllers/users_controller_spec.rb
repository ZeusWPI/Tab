# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController do
  let(:user) { create(:penning) }

  before do
    sign_in user
  end

  describe "GET show" do
    before do
      get :show, params: { id: user }
    end

    it "is successful" do
      expect(response).to render_template(:show)
      expect(response).to have_http_status(:ok)
    end

    it "loads the correct user" do
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET index" do
    before do
      get :index
    end

    it "loads an array of all users" do
      expect(assigns(:users)).to eq([user])
    end

    it "renders the correct template" do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end
end
