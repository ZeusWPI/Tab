Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'callbacks'
  }

  devise_scope :user do
    delete '/sign_out', to: 'devise/sessions#destroy'
  end

  authenticated :user do
    root 'pages#landing', as: :authenticated_root
  end

  root to: 'pages#sign_in_page'

  resources :transactions, only: [:create]
  resources :users,        only: [:index, :show] do
    resources :requests, only: [:index], shallow: true do
      post :confirm
      post :decline
    end
    resources :notifications, only: [:index], shallow: true do
      post :read
    end
    resources :transactions, only: [:index], shallow: true
    post :reset_key, on: :member
  end

  get 'datatables/:id' => 'datatables#transactions_for_user', as: "user_transactions_datatable"
end
