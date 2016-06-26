Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'signup' }

  root 'activities#index'
  get 'current_session', to: 'sessions#show'

  resources :activities, only: [:index]
  resources :blogs
  resources :recipes
  resources :reviews


end
