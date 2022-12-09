Rails.application.routes.draw do
  # we remove all routes generated by devise because they
  # assume the app has views and forms
  devise_for :users, skip: :all
  devise_scope :user do
    scope :api, defaults: { format: :json } do
      post   '/login',        to: 'sessions#create'
      delete '/logout',       to: 'sessions#destroy'
      post   '/signup',       to: 'registrations#create'
      put    '/account',      to: 'registrations#update'
      delete '/account',      to: 'registrations#destroy'
      put    '/password',     to: 'devise/passwords#update'
      post   '/password',     to: 'devise/passwords#create'
      get    '/confirmation', to: 'devise/confirmations#show'
    end
  end

  resources :notes
  resources :shares
end
