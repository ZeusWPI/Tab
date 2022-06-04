# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    omniauth_callbacks: 'callbacks'
  }

  devise_scope :user do
    # get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get '/sign_out', to: 'devise/sessions#destroy' # , as: :destroy_user_session
  end

  authenticated(:user) do
    root 'pages#landing', as: :authenticated_root
  end

  root to: 'pages#sign_in_page'

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

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :transactions, only: [:create]

      resources :users, only: [:index, :show] do
        resources :transactions, only: [:index]
      end
    end
  end

  get 'datatables/:id' => 'datatables#transactions_for_user', as: "user_transactions_datatable"
end
