module Contenter
  class CoursesController < HomeController
    before_action :authorize
    helper_method :current_user
    layout "application"

    def index
    end

    def edit
    end

  end
end
