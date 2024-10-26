Rails.application.routes.draw do
  get "communities/new"
  root "static_pages#home"
  get  "/rag",    to: "static_pages#rag"
  get  "/about",   to: "static_pages#about"
  get  "/feedback", to: "static_pages#feedback"
  get  "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get  "/make",  to: "communities#new"
  resources :users
  resources :communities, only: [:index, :new, :show, :create, :destroy]
  resources :questions, only: [:create, :destroy]
end
