Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  # You can have the root of your site routed with "root"
  root 'home#index'

  namespace :users do
    get '/unverified_account', to: 'unverified#show'
    post '/unverified_account/resend_confirmation', to: 'unverified#resend_confirmation'
  end
end
