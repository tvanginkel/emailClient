Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'email#inbox'

  # Authentication routes
  get 'auth/login', to: 'auth#login'
  get 'auth/register'
  post 'auth/register', to: 'auth#create_account'
  post 'auth/login', to: 'auth#login_account'
  get 'auth/logout'

  # Email routes
  get 'email/inbox'
  post 'email/inbox', to: 'email#create_inbox'
  post 'email/change_inbox'
  delete 'email/remove_inbox'
  get 'email/new_email'
  post 'email/new_email', to: 'email#create_email'
  get 'email/delete_email'
  get 'email/view_email'

  # Contact routes
  get 'contact/contact'
  post 'contact/contact', to: 'contact#send_contact'

  # Profile routes
  get 'profile/profile'
  post 'profile/profile', to: 'profile#change_password'
  delete 'profile/profile', to: 'profile#delete_account'
end
