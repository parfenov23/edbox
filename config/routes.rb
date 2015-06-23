Rails.application.routes.draw do

  root to: 'application#index_page'
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
        end
      end
      resources :groups do
        member do
          post :invite
          post :remove_user
        end
        collection do
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
    resources :attachments do
      member do
        get :remove
      end
    end
  end

end
