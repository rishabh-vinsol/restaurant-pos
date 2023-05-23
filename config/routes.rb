Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"

  controller :registrations do
    get :signup
    post 'signup' => :create_user
    get :login
    post 'login' => :login_user
    delete :logout
    get :resend_email
    post 'resend_email' => :resend_verification_email
    get :verify_email
    get :reset_password
    post 'reset_password' => :reset_password_email
    get 'reset_password/edit' => :reset_password_edit
    patch 'reset_password' => :update_password
  end

  resources :users, except: :show do 
    member do
      get :send_authentication_email
      get :send_password_reset_email
    end
  end
end
