Rails.application.routes.draw do

  root to: 'home#index'
  get :sign_in, to: "enter#sign_in"
  get :sign_up, to: "enter#sign_up"
  get :sign_out, to: "enter#sign_out"
  get :reset_pass, to: "enter#reset_pass"
  get :oferta, to: "enter#oferta"
  post :render_mini_schedule, to: "home#render_mini_schedule"

  get "video/:id" => "home#video"
  get "audio/:id" => "home#audio"
  get "pdf/:id" => "home#pdf"
  get 'schedule', to: "schedules#index"
  post 'schedule/day', to: "schedules#day_schedule"
  get "makeup/:action" => "makeup#:action"
  post "subscription/pay" => "home#pay"
  get "director/:action" => "director#:action"
  get "director/statistic/:action" => "director#:action"
  get ":action" => "home#:action"

  #home routes
  get "course_description/:id" => "home#course_description"
  get "attachment/:id" => "home#attachment"
  get "user/:id" => "home#user"
  get "courses/:type" => "home#courses"
  get "group/:id" => "home#group"
  get "help_answer/:id" => "home#help_answer"
  #########

  # get "makeup/create_group/name" => "makeup/create_group#name", :controller => "makeup"
  namespace :makeup do
    resources :create_group do
      collection do
        get ":action" => "create_group#:action"
      end
    end
    resources :contenter do
      collection do
        get ":action" => "contenter#:action"
      end
    end
    resources :director do
      collection do
        get ":action" => "director#:action"
      end
    end
    resources :billing do
      collection do
        get ":action" => "billing#:action"
      end
    end
  end
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

  namespace :api do
    namespace :v1 do
      resources :tests do
        member do
          get :get_test
          get :certificate
          post :result
          post :remove
        end
      end

      resources :notices do
      end

      resources :webinars do
        member do
          post :remove
          post :all_leading
          post :add_leading
          post :remove_leading
          post :event_create
          post :event_start
          post :event_stop
          post :event_reg_user
          post :event_un_reg_user
          post :event_reg_group
          post :event_unreg_group
        end
      end

      resources :payments do
        collection do
          post :update_card
          post :post3ds
          post :remove_card
          post :purchase
          post :order_bill
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

      resources :news do
        member do
          post :read
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
          post :update_teaser_material
          post :remove_teaser_material
          post :remove_tag
          post :remove_category
          post :remove
          post :add_leading
          post :remove_leading
          post :update_type
          post :update_teaser
          post :remove_teaser
          post :complete_material
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
          post :remove_user_leading
          post :send_request
          get :my_courses
        end
        member do

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

    resources :ask_questions do
      member do
        post :remove
      end
    end

    resources :page_questions do
      member do
        post :remove
      end
    end

    resources :companies do
      member do
        get :remove
      end
    end

    resources :delivery do
      member do
        get :remove
        get :send_mail
      end
      collection do
        get :result
        get :help
      end
    end

    resources :news do
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
    resources :billing do
      member do
        get :all
        get :remove
      end
      collection do
        get :edit_price
        post :update_price
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
    resources :email_notifs do
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
    resources :materials do
      collection do
      end
      member do
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

  #yandex money
  get '/money/purse/refill', :to => 'money/purse#refill', :as => :refill #пополнение кошелька
  post '/money/purse/refill_process', :to => 'money/purse#refill_process', :as => :refill_process #/пополнение/счета
  get '/money/purse/payment_fail', :to => 'money/purse#payment_fail', :as => :payment_fail #/платеж/не/прошел
  get '/money/purse/payment_success/:secure_code', :to => 'money/purse#payment_success', :as => :payment_success #/платеж/прошел/:secure_code

  get '*unmatched_route', :to => "home#page_404"
end
