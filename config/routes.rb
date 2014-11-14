Rails.application.routes.draw do
  root to: 'pages#index'

  get ':page', to: 'pages#index'
  get 'protected', to: 'api#protected'
  
  post 'login', to: 'sessions#new'
  post 'sign_up', to: 'users#new'
end
