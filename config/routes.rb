Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  devise_for :users,
   controllers: {
     omniauth_callbacks: "omniauth_callbacks",
     registrations: "registrations"
   }
  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/policy", to: "static_pages#policy"
  get "/terms", to: "static_pages#terms"
  resources :users, only: [:index, :show] do
    member do
      get :following, :followers, :comments
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :portfolios, except: [:index] do
    resources :progresses do
      resources :comments, except: [:show]
    end
  end
  resources :favorites, only: [:create, :destroy]
  get "rankings/favorite"
  get "rankings/total_pv"
  get "rankings/weekly_pv"
end
