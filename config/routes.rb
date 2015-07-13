Rails.application.routes.draw do

  root to: 'application#index_page'
  get :sign_in, to: "enter#sign_in"
  get :sign_up, to: "enter#sign_up"
  get :sign_out, to: "enter#sign_out"
  get :oferta, to: "enter#oferta"

  get ":action" => "home#:action"

  namespace :api do
    namespace :v1 do
      resources :sessions, only: [] do
        collection do
          post :auth
          post :registration
          get :signout
        end
      end
      resources :users, only: [] do
        collection do
          get :info
          post :invite
          post :change_password
          post :update
          post :update_avatar
          post :remove_user
          post :add_favorite_course
          post :remove_favorite_course
        end
      end
      resources :groups do
        member do
          get :all_course
          post :invite
          post :remove_user
          post :remove_course
        end
        collection do
          post :add_course
        end
      end
    end
  end

  namespace :superuser do
    resources :home, only: [] do
      collection do
        get :index
      end
    end
    resources :companies do
      member do
        get :remove
      end
    end
    resources :users do
      member do
        get :remove
        get :add_favorite_course
        get :remove_favorite_course
        post :create_favorite_course
      end
      collection do
        get :all_leading
      end
    end
    resources :groups do
      member do
        get :remove
        get :add_user
        get :remove_user
        get :add_course
        post :update_course
        get :edit_course
        get :remove_course
      end
    end
    resources :courses do
      member do
        get :remove
      end
    end
    resources :sections do
      member do
        get :remove
      end
    end
    resources :tests do
      member do
        get :remove
      end
    end
    resources :questions do
      member do
        get :remove
      end
    end
    resources :answers do
      member do
        get :remove
      end
    end
    resources :tags do
      member do
        get :remove
      end
    end
    resources :attachments do
      member do
        get :remove
      end
    end
  end

end
