Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/policy", to: "static_pages#policy"
  get "/terms", to: "static_pages#terms"
  resources :users, only: [:show]
end
