Rails.application.routes.draw do
  # ActiveAdmin.routes(self)
  root to: 'pages#index'
  get ':page', to: 'pages#index'

  get 'protected', to: 'api#protected'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#delete'
  post 'sign_up', to: 'users#create'
end
