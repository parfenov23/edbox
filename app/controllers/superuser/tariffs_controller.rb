module Superuser
  class TariffsController < SuperuserController

    def index
      @tariffs = Tariff.all
    end

    def edit
      @tariff = find_tariffs
    end

    def new
      @tariff = Tariff.new
    end

    def create
      tariff = Tariff.new(params_tariff)
      tariff.save
      redirect_to edit_superuser_tariff_path(tariff.id, params: {error: "save"})
    end

    def update
      tariff = find_tariffs
      tariff.update(params_tariff)
      redirect_to :back
    end

    def remove
      find_tariff.destroy
      redirect_to :back
    end

    private

    def find_tariffs
      Tariff.find(params[:id])
    end

    def params_tariff
      params.require(:tariff).permit(:title, :active, :type_tariff, :price).compact rescue {}
    end
  end
end
