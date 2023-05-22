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
    get :verify_email
    get :forgot_password
    post 'forgot_password' => :forgot_password_email
    get 'forgot_password/edit' => :forgot_password_edit
    patch 'forgot_password' => :update_password
  end

  resources :users, except: :show
  resources :branches, except: :show
end
