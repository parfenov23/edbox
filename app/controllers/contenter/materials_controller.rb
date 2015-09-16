module Contenter
  class MaterialsController < HomeController
    before_action :authorize
    helper_method :current_user
    before_action :is_contenter?
    layout "application"

    def index
    end

    def edit
    end

  end
end
