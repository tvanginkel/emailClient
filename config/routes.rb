Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'auth/login', to: 'auth#login'
  get 'auth/register'
  post 'auth/register', to: 'auth#create_account'
  post 'auth/login', to: 'auth#login_account'
  get 'auth/logout'
end
