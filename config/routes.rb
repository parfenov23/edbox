Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      #=============

      resources :sessions, only: [] do
        collection do
          post :auth
          post :registration
        end
      end
      resources :users, only: [] do
        collection do
          get :info
          post :invite
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

      #=============
    end
  end

  #=================
  root "home#index"
end
