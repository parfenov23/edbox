Rails.application.routes.draw do

  root to: 'home#index_page'
  get :sign_in, to: "enter#sign_in"
  get :sign_up, to: "enter#sign_up"
  get :sign_out, to: "enter#sign_out"
  get :oferta, to: "enter#oferta"
  post :render_mini_schedule, to: "home#render_mini_schedule"

  bigbluebutton_routes :default

  get "video/:id" => "home#video"
  get "audio/:id" => "home#audio"
  get "pdf/:id" => "home#pdf"
  get 'schedule', to: "schedules#index"
  post 'schedule/day', to: "schedules#day_schedule"
  get "makeup/:action" => "makeup#:action"
  # get "test_websocket" => "home#test_websocket"
  # get 'nod'
  match "node/websocket", :to => WebsocketRails::ConnectionManager.new, :via => [:get, :post]
  resources :tests, only: [] do
    collection do
      post :complete
    end
    member do
      get :run
    end
  end

  resources :notes, only: [:index, :destroy] do
    collection do
      post 'update'
    end
    member do
      post :info
    end
  end

  get ":action" => "home#:action"

  namespace :api do
    namespace :v1 do
      resources :tests do
        member do
          get :get_test
          post :result
          post :remove
        end
      end
      resources :webinars do
        member do
          post :remove
          post :all_leading
          post :add_leading
          post :remove_leading
        end
      end

      resources :questions do
        member do
          post :remove
        end
      end

      resources :answers do
        member do
          post :remove
        end
      end

      resources :tags do
        member do
          post :remove
        end
      end

      resources :categories do
        member do
          post :remove
        end
      end

      resources :sessions, only: [] do
        collection do
          post :auth
          post :registration
          post :recover_password
          get :signout
        end
      end
      resources :companies, only: [] do
        collection do
          get :info
        end
      end

      resources :attachments do
        member do
          get :render_file
          post :complete
          post :remove
          post :attachment_contenter_html
          post :set_type
        end
        collection do
          post :update_positions
        end
      end
      resources :sections do
        member do
          post :contenter_html
          post :remove
        end
      end

      resources :courses do
        collection do
          get :all
        end
        member do
          get :info
          post :add_tag
          post :add_category
          post :remove_tag
          post :remove_category
          post :add_leading
          post :remove_leading
          post :update_type
          post :update_teaser
          post :remove_teaser
        end
      end

      resources :users, only: [] do
        collection do
          get :info
          post :invite
          post :change_password
          post :update
          post :update_avatar
          post :update_avatar_string
          post :remove_user
          post :add_favorite_course
          post :remove_favorite_course
          post :update_course
          post :remove_course
          post :update_section
          post :remove_section_deadline
        end
        member do
          post :remove_user_leading
        end
      end
      resources :groups do
        member do
          get :all_course
          post :invite
          post :remove_user
          post :remove_course
          post :update_course
          post :update_section
        end
        collection do
          post :add_course
          post :add_courses
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
    resources :account_types do
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

  namespace :contenter do
    resources :courses do
      collection do
      end
      member do
        get :program
        get :publication
      end
    end
    resources :admin do
      collection do
        get :tags
        get :members
        get :categories
      end
      member do
      end
    end
  end

end
