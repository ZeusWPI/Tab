Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'callbacks'
  }

  root to: 'pages#landing'

  resources :transactions, only: [:index, :create]
  resources :users, only: [:show, :index]
end
