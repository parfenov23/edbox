module Api::V1
  class WebinarsController < ::ApplicationController

    def update
      webinar = find_webinar
      webinar_params_permit = webinar_params
      webinar_params_permit[:date_start] = (Time.parse(webinar_params_permit[:date_start]) + (User.time_zone).hour) if webinar_params_permit[:date_start].present?
      webinar.update(webinar_params_permit)
      # binding.pry
      render json: webinar.transfer_to_json
    end

    def all_leading
      render json: find_webinar.ligament_leads.map{|ll| ll.user.id}
    end

    def add_leading
      webinar = find_webinar
      ligament_lead = webinar.ligament_leads.find_or_create_by({user_id: params[:user_id]})
      if params[:type] == "html"
        html_result = render_to_string "contenter/courses/program/_webinar_leading", :layout => false,
                                       :locals => {user: ligament_lead.user, webinar: webinar}
        render text: html_result
      else
        render json: ligament_lead.transfer_to_json
      end
    end

    def remove_leading
      webinar = find_webinar
      webinar.ligament_leads.where(user_id: params[:user_id]).destroy_all
      render json: {success: true}
    end

    def create
    end

    def remove
      find_webinar.destroy
      render json: {success: true}
    end

    private

    def webinar_params
      params.require(:webinar).permit(:duration, :date_start).compact.select { |k, v| v != "" } rescue {}
    end

    def find_webinar
      Webinar.find(params[:id])
    end

  end
end
