Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/policy", to: "static_pages#policy"
  get "/terms", to: "static_pages#terms"
  resources :users, only: [:show] do
    member do
      get :following, :followers, :favorites
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :portfolios, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :favorites, only: [:create, :destroy]
  get "rankings/favorite"
end
