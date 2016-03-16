module Api::V1
  class NoticesController < ::ApplicationController
    skip_before_action :authorize, only: [:create]

    def create
      notice = Notice.new(notice_params)
      notice.save
      (HomeMailer.notice_confirm(notice.email, notice.course).deliver rescue nil)
      render json: notice.as_json
    end

    private

    def notice_params
      params.require(:notice).permit(:email, :course_id).compact.select { |k, v| v != "" } rescue {}
    end
  end
end
