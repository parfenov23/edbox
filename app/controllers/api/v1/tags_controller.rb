module Api::V1
  class TagsController < ::ApplicationController

    def update
      tag = find_tag
      tag.update(tag_params)
      render json: tag.transfer_to_json
    end

    def create
      tag = Tag.new(tag_params)
      tag.save
      if params[:type] == "html"
        html_result = render_to_string "contenter/admin/_tag", :layout => false,
                                       :locals => {tag: tag}
        render text: html_result
      else
        render json: tag.transfer_to_json
      end
    end

    def remove
      find_tag.destroy
      render json: {success: true}
    end

    private

    def tag_params
      params.require(:tag).permit(:title).compact.select { |k, v| v != "" } rescue {}
    end

    def find_tag
      Tag.find(params[:id])
    end

  end
end
