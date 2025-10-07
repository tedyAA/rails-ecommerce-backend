Rails.application.routes.draw do
  namespace :api do
    get 'cart_items/create'
    get 'cart_items/update'
    get 'cart_items/destroy'
    get 'carts/show'
  end
  namespace :admin do
    resources :products
    resources :types
    resources :categories
    resources :users
    resources :orders
    resources :dashboard
  end
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  authenticated :admin_user do
    root to: "dashboard#index", as: :admin_root
  end

  get "admin" => "admin#index"
# API
  namespace :api do
    resources :products, only: [:index, :show]
    resources :types, only: [:index]
    resources :categories, only: [:index]

    resources :carts, only: [:show]
    resources :cart_items, only: [:create, :update, :destroy]

    resources :orders, only: [:create, :show, :index]

    resources :users, only: [:create, :update]
    post 'login', to: 'sessions#create'
    get '/current_user', to: 'users#current'
    patch 'users/update_avatar', to: 'users#update_avatar'
  end
end
