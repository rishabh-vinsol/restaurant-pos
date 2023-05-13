Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  controller :registrations do
    get "signup" => :new
    post "signup" => :create
  end

  controller :confirmations do
    get :verify_email
  end

  controller :sessions do
    get "login" => :new
    post "login" => :create
    delete "logout" => :destroy
  end
  
  resources :users
end
