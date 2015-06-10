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

      #=============
    end
  end

  #=================
  root "home#index"
end
