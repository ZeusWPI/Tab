Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'callbacks'
  }

  root to: 'high_voltage/pages#show', id: "landing"

  resources :transactions, only: [:new, :index, :create]
  resources :users, only: [:show, :index]
end
