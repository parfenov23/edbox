module Superuser
  class TariffInfosController < SuperuserController

    def index
      @tariff_infos = TariffInfo.all
    end

    def edit
      @tariff_info = find_tariff_info
    end

    def new
      @tariff_info = TariffInfo.new
    end

    def create
      tariff_info = TariffInfo.new(params_tariff_info)
      tariff_info.save
      redirect_to edit_superuser_tariff_info_path(tariff_info.id, params: {error: "save"})
    end

    def update
      # binding.pry
      tariff_info = find_tariff_info
      tariff_info.update(params_tariff_info)
      tariff_info.array_ids = params[:tariff_info][:array_ids]
      tariff_info.save
      redirect_to :back
    end

    def remove
      find_tariff_info.destroy
      redirect_to :back
    end

    private

    def find_tariff_info
      TariffInfo.find(params[:id])
    end

    def params_tariff_info
      params.require(:tariff_info).permit(:title, :array_ids).compact rescue {}
    end
  end
end
