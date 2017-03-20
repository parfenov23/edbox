module Superuser
  class CardCategoriesController < SuperuserController

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
      redirect_to superuser_card_category_path(@model.id, params: {error: "save"})
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

    def model
      CardCategory
    end

    def find_model
      model.find(params[:id])
    end

    def params_model
      params.require(model.to_s.split(/(?=[A-Z])/).join("_").downcase.to_sym).permit(model.column_names).compact.select { |k, v| v != "" } rescue {}
    end
  end
end
