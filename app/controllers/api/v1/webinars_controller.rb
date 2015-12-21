module Api::V1
  class WebinarsController < ::ApplicationController

    def update
      webinar = find_webinar
      webinar_params_permit = webinar_params
      if webinar_params_permit[:date_start].present?
        utc_strt = webinar_params_permit[:date_start].gsub(".", "-").gsub(" ", "T") + "Z"
        curr_time = Time.parse(utc_strt) - (User.time_zone).hour
        webinar_params_permit[:date_start] = curr_time
      end
      webinar.update(webinar_params_permit)
      render json: webinar.transfer_to_json
    end

    def all_leading
      render json: find_webinar.ligament_leads.map { |ll| ll.user.id }
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

    def event_create
      webinar = find_webinar
      webinar.eventCreate
      render json: {success: true}
    end

    def event_start
      webinar = find_webinar
      webinar.eventStart
      render json: {success: true}
    end

    def event_stop
      webinar = find_webinar
      webinar.eventStop
      render json: {success: true}
    end

    def event_reg_group
      webinar = find_webinar
      group = Group.find(params[:group_id])
      group_webinar = group.group_webinar
      if group_webinar.blank?
        group.bunch_groups.each do |bunch_group|
          webinar.eventRegUser(bunch_group.user)
        end
        GroupWebinar.create({webinar_id: webinar.id, group_id: group.id})
        render json: {success: true}
      else
        render json: {success: false}
      end
    end

    def event_unreg_group
      webinar = find_webinar
      group = Group.find(params[:group_id])
      group_webinar = group.group_webinar
      if group_webinar.present?
        group.bunch_groups.each do |bunch_group|
          webinar.eventUnRegUser(bunch_group.user)
        end
        group_webinar.destroy
        render json: {success: true}
      else
        render json: {success: false}
      end
    end

    def event_reg_user
      webinar = find_webinar
      user = User.find params[:user_id]
      if user.present?
        webinar.eventRegUser(user)
        render json: {success: true}
      else
        render json: {success: false}
      end
    end

    def event_un_reg_user
      webinar = find_webinar
      user = User.find params[:user_id]
      if user.present?
        webinar.eventUnRegUser(user)
        HomeMailer.unreg_webinar(webinar, user).deliver
        render json: {success: true}
      else
        render json: {success: false}
      end
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
