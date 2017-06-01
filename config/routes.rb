Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  root 'home#index'
  get '/sessions/destroy', to: 'sessions#destroy'
  resources :sessions, only: [:new, :create]
  resources :stats, only: :index
  resources :flagged_posts
  resources :posts
end
