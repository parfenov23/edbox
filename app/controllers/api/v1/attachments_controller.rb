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
        bunch_attachment.bunch_section.full_complete?
        render json: bunch_attachment.as_json
      else
        render_error(500, 'Проверьте данные')
      end
    end

    private

    def find_attachment
      Attachment.find(params[:id])
    end

    def find_user
      User.find_by(user_key: params[:hash])
    end

  end

end
