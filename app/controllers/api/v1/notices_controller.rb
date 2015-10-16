module Api::V1
  class NoticesController < ::ApplicationController
    def create
      notice = Notice.new(notice_params)
      notice.save
      render json: notice.as_json
    end

    private
    def notice_params
      params.require(:notice).permit(:email, :course_id).compact.select { |k, v| v != "" } rescue {}
    end
  end
end
