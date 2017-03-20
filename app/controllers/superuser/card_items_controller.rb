module Superuser
  class CardItemsController < SuperuserController

    def index
      @models = model.all
    end

    def edit
      @model = find_model
    end

    def new
      @model = model.new
    end

    def create
      @model = model.new(params_model)
      @model.save
      redirect_to index_redirect
    end

    def show
      @model = find_model
      @under_models = @model.card_items
    end

    def update
      model = find_model
      model.update(params_model)
      redirect_to :back
    end

    def remove
      find_model.destroy
      redirect_to :back
    end

    private

    def index_redirect
      if @model.card_category_id.present?
        superuser_card_category_path(@model.card_category_id, params: {error: "save"})
      elsif @model.card_id.present?
        superuser_card_item_path(@model.card_id, params: {error: "save"})
      end
    end

    def model
      CardItem
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(model.to_s.split(/(?=[A-Z])/).join("_").downcase.to_sym).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end
