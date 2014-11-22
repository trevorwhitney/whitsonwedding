Rails.application.routes.draw do
  root to: 'pages#index'
  get ':page', to: 'pages#index'

  namespace :api do
    get 'protected', to: 'api#protected'
    post 'login', to: 'sessions#new'
    delete 'logout', to: 'sessions#delete'
    post 'sign_up', to: 'users#new'
  end
end
