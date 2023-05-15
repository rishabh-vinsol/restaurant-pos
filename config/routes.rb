Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'store#index'

  get 'store/index'
  controller :registrations do
    get 'signup' => :new
    post 'signup' => :create
  end

  controller :confirmations do
    get :verify_email
  end

  controller :passwords do
    get 'forgot_password' => :new
    post 'forgot_password' => :create
    get 'forgot_password/edit' => :edit
    patch 'forgot_password' => :update
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
end
