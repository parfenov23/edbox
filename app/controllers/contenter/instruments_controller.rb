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

    def upload_file_img
      att = Attachment.create(file: params[:file])
      render json: {
               image: {
                 url: att.file.url
               }
             }, content_type: "text/html"
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
