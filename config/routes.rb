# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    omniauth_callbacks: "callbacks"
  }

  devise_scope :user do
    # get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get "/sign_out", to: "devise/sessions#destroy" # , as: :destroy_user_session
  end

  authenticated(:user) do
    root "pages#landing", as: :authenticated_root
  end

  root to: "pages#sign_in_page"

  require "sidekiq/web"
  require "sidekiq/cron/web"
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    username == Rails.application.secrets.sidekiq_admin_username &&
      password == Rails.application.secrets.sidekiq_admin_password
  end
  mount Sidekiq::Web => "/sidekiq"

  resources :transactions, only: [:create]
  resources :users, only: [:index, :show] do
    resources :requests, only: [:index], shallow: true do
      post :confirm
      post :decline
      post :cancel
    end
    resources :notifications, only: [:index], shallow: true do
      post :read
    end
    resources :transactions, only: [:index]
    post :reset_key, on: :member
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :transactions, only: [:create]
      resources :requests, only: [:index], shallow: true do
        post :confirm
        post :decline
        post :cancel
      end

      resources :users, only: [:index, :show] do
        resources :transactions, only: [:index]
        resources :requests, only: [:index]
      end
    end
  end

  get "datatables/:id" => "datatables#transactions_for_user", as: "user_transactions_datatable"

  # API goodies
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
end
