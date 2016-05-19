module Api::V1
  class AttachmentsController < ApplicationController
    skip_before_action :authorize, only: [:render_file]

    def render_file
      user = find_user
      attachment = find_attachment
      if user.present? || attachment.public
        file_path = Rails.root.to_s+"/public"+attachment.file.to_s
        file_type = attachment.file.file.content_type
        send_file file_path, :type => file_type, :filename => attachment.file.file.filename
      else
        render_error(401, 'Не удалось пройти аутентификацию, проверьте введенные данные')
      end
    end

    def complete
      bunch_attachments = current_user.bunch_courses.find_bunch_attachments.where(attachment_id: params[:id])
      bunch_attachments.each do |bunch_attachment|
        bunch_attachment.complete = true
        if ((bunch_attachment.save) rescue false)
          bunch_attachment.bunch_section.full_complete?(current_user.id)
        end
      end
      render json: bunch_attachments.map(&:as_json)
    end

    def update
      # binding.pry
      attachment = params[:id] != "new" ? find_attachment : Attachment.create(params_attachment)
      attachment.update(params_attachment)
      # attachment.work_to_video
      render json: attachment.transfer_to_json
    end

    def remove
      attachment = find_attachment
      attachment.webinar.clear_users if attachment.webinar.present?
      attachment.destroy
      render json: {success: true}
    end

    def attachment_contenter_html
      attachment_html = render_to_string "contenter/courses/program/_attachment", :layout => false, :locals => {attachment: find_attachment,
                                                                                                                class_state: params[:class_state],
                                                                                                                section: find_attachment.attachmentable}
      render text: attachment_html
    end

    def create
      attachment = Attachment.new({attachmentable_id: params[:attachmentable_id],
                                   attachmentable_type: params[:attachmentable_type], file_type: params[:file_type]})
      attachment.save
      # if attachment.file_type == "webinar"
      #   webinar = Webinar.create({attachment_id: attachment.id})
      #   webinar.eventCreate
      # end
      Webinar.create({attachment_id: attachment.id}) if attachment.file_type == "webinar"
      attachment.install_position
      render json: attachment.transfer_to_json
    end

    def set_type
      attachment= find_attachment
      hash = {file_type: params[:type], download: false}
      hash = {download: params[:type], download: true} if params[:type] == "download"
      attachment.update(hash)
      render json: attachment.transfer_to_json
    end

    def update_positions
      ids_sections = params[:ids_sections]
      n = -1
      position_s = 0
      ids_sections.each do |id_section|
        Section.find(id_section).update({position: (position_s += 1)})
        position = 0
        arr_ids = params[:ids_attachments][(n+=1).to_s]
        if arr_ids.present?
          arr_ids.each do |id_attachment|
            attachment = Attachment.find(id_attachment)
            attachment.update({position: (position+=1), attachmentable_type: "Section", attachmentable_id: id_section})
          end
        end
      end
      render json: {success: true}
    end

    private

    def find_attachment
      Attachment.find(params[:id])
    end

    def params_attachment
      params.require(:attachment).permit(:title, :description, :file, :full_text, :duration, :attachmentable_type, :attachmentable_id).compact rescue {}
    end

    def find_user
      User.find_by(user_key: params[:hash])
    end

  end

end
