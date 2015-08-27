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
      attachment = find_attachment
      bunch_attachment = attachment.find_bunch_attachment(params[:bunch_section_id])
      bunch_attachment.complete = true
      if ((bunch_attachment.save) rescue false )
        bunch_attachment.bunch_section.full_complete?(current_user.id)
        render json: bunch_attachment.as_json
      else
        render_error(500, 'Проверьте данные')
      end
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

    private

    def find_attachment
      Attachment.find(params[:id])
    end

    def params_attachment
      params.require(:attachment).permit(:title, :description, :file, :full_text, :duration).compact.select{|k,v| v != ""} rescue {}
    end

    def find_user
      User.find_by(user_key: params[:hash])
    end

  end

end
