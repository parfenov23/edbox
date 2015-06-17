module Superuser
  class HomeController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize
  end
end
