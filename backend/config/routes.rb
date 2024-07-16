Rails.application.routes.draw do
  resources :registrations, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :persons, only: [:index, :show, :create, :update, :destroy]
end