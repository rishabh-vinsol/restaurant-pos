Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'items#menu'

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

  scope module: 'admin' do
    resources :users, except: :show do 
      member do
        get :send_authentication_email
        get :send_password_reset_email
      end
    end

    resources :branches, except: :show do
      resources :inventories do
        get :logs, on: :member
      end
      member do
        get :meals
        get :add_meal
        post 'add_meal', to: 'branches#create_meal'
        get :toggle_meal_active
        get :toggle_meal_inactive
      end
    end

    resources :meals, except: :show do
      member do
        get :toggle_active
        get :toggle_inactive
      end
    end

    resources :ingredients, except: :show
  end

  controller :items do 
    get :menu
    post :set_branch
    post :set_meal_non_veg
  end

  controller :orders do
    get :cart
    get :order_success
    get :order_cancel
    post :add_to_cart
    post :update_line_item_quantity
    patch :checkout
    delete :destroy_line_item
    delete :empty_cart
  end
end
