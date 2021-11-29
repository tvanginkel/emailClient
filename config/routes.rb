Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Home routes //TODO: stop using this routes and delete them
  root 'home#index'
  get 'home/index'

  # Authentication routes
  get 'auth/login', to: 'auth#login'
  get 'auth/register'
  post 'auth/register', to: 'auth#create_account'
  post 'auth/login', to: 'auth#login_account'
  get 'auth/logout'

  # Email routes
  get 'email/inbox'
  post 'email/inbox', to: 'email#create_inbox'
  get 'email/new_email'
  post 'email/new_email', to: 'email#create_email'

  # Contact routes
  get 'contact/contact'
  post 'contact/contact', to: 'contact#send_contact'

  # Profile routes
  get 'profile/profile'
  post 'profile/profile', to: 'profile#change_password'
end
