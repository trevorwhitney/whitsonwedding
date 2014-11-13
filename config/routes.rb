Rails.application.routes.draw do
  get 'protected', to: 'api#protected'
  
  post 'login', to: 'sessions#new'
  post 'sign_up', to: 'users#new'
end
