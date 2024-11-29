Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :users
  resources :currencies
  resources :operations # , only, only: [:index, :show, :destroy]
  resources :user_accounts # , only, only: [:index, :show, :destroy]
end
