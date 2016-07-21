module Contenter
  class InstrumentsController < HomeController
    before_action :authorize
    helper_method :current_user
    before_action :is_contenter?
    layout "application"

    def index
    end

    def edit
    end

    def publication
      begin
        @course = Course.find(params[:id])
      rescue
        redirect_to "contenter/instruments/new/edit"
      end
    end

  end
end
