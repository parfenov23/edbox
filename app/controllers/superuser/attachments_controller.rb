module Superuser
  class AttachmentsController < SuperuserController

    def index
      @group = Attachment.all
    end

    def edit
      @attachment = find_attachment
      @back_url = "/superuser/#{@attachment.attachmentable_type.downcase}s/#{@attachment.attachmentable_id}/edit"
    end

    def new
      @attachment = Attachment.new
      @back_url = "/superuser/#{params[:model_type].downcase}s/#{params[:model_id]}/edit"
    end

    def create
      attachment = Attachment.save_file(params[:model_type], params[:model_id], params_attachment[:file])
      attachment.title = params_attachment[:title]
      attachment.duration = params_attachment[:duration]
      attachment.save
      redirect_to "/superuser/#{params[:model_type].downcase}s/#{params[:model_id]}/edit"
    end

    def update
      find_attachment.update(params_attachment.compact)
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
      params.require(:attachment).permit(:file, :attachmentable_type, :attachmentable_id, :title, :duration, :public).compact rescue {}
    end
  end
end
