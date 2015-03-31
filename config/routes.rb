Rails.application.routes.draw do
  # ActiveAdmin.routes(self)
  root to: 'pages#index'
  get ':page', to: 'pages#index'

  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#delete'
  post 'sign_up', to: 'users#create'
end
