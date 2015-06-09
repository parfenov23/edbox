Rails.application.routes.draw do
  get ':controller/:action'
  root "home#index"
end
