module Superuser
  class AttachmentsController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @group = Attachment.all
    end

    def edit
      @attachment = find_attachment
      # @back_url = "/superuser/companies/#{@group.company.id}/edit?type=group"
    end

    def new
      @attachment = Attachment.new
      @back_url = "/superuser/#{params[:model_type].downcase}s/#{params[:model_id]}/edit"
    end

    def create
      Attachment.save_file(params[:model_type], params[:model_id], params_attachment[:file])
      redirect_to "/superuser/#{params[:model_type].downcase}s/#{params[:model_id]}/edit"
    end

    def update
      find_attachment.update(params_attachment)
      redirect_to :back
    end

    def remove
      find_attachment.destroy
      redirect_to :back
    end

    private

    def find_attachment
      Attachment.find(params[:id])
    end

    def params_attachment
      params.require(:attachment).permit(:file, :attachmentable_type, :attachmentable_id)
    end

  end
end
