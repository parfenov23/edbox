module Api::V1
  class AttachmentsController < ApplicationController
    skip_before_action :authorize, only: [:render_file]

    def render_file
      user = find_user
      if user.present?
        attachment = find_attachment
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
      attachment = find_attachment
      attachment.update(params_attachment)
      render json: attachment.transfer_to_json
    end

    def remove
      find_attachment.destroy
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
                                   attachmentable_type: params[:attachmentable_type]})
      attachment.save
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
      ids_sections.each do |id_section|
        position = 0
        params[:ids_attachments][(n+=1).to_s].each do |id_attachment|
          attachment = Attachment.find(id_attachment)
          attachment.update({position: (position+=1), attachmentable_type: "Section", attachmentable_id: id_section})
        end
      end
      render json: {success: true}
    end

    private

    def find_attachment
      Attachment.find(params[:id])
    end

    def params_attachment
      params.require(:attachment).permit(:title, :description, :file, :full_text, :duration).compact.select { |k, v| v != "" } rescue {}
    end

    def find_user
      User.find_by(user_key: params[:hash])
    end

  end

end
