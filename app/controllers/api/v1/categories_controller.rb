module Api::V1
  class CategoriesController < ::ApplicationController

    def update
      category = find_category
      category.update(category_params)
      render json: category.transfer_to_json
    end

    def create
      category = Category.new(category_params)
      category.save
      if params[:type] == "html"
        html_result = render_to_string "contenter/admin/_category", :layout => false,
                                       :locals => {category: category}
        render text: html_result
      else
        render json: category.transfer_to_json
      end
    end

    def remove
      find_category.destroy
      render json: {success: true}
    end

    private

    def category_params
      params.require(:category).permit(:title).compact.select { |k, v| v != "" } rescue {}
    end

    def find_category
      Category.find(params[:id])
    end

  end
end
