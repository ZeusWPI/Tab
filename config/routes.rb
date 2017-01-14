Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'callbacks'
  }

  authenticated :user do
    root 'pages#landing', as: :authenticated_root
  end

  root to: 'pages#sign_in_page'

  resources :transactions, only: [:index, :create]
  resources :users,        only: [:index, :show] do
    resources :requests, only: [:index], shallow: true do
      post :confirm
      post :decline
    end
    resources :notifications, only: [:index], shallow: true do
      post :read
    end
  end

  get 'datatables/:id' => 'datatables#transactions_for_user', as: "user_transactions"
end
