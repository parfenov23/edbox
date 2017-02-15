module Superuser
  class AdsController < SuperuserController

    def index
      # @answers = Answer.where(question_id: params[:question_id])
    end

    def edit
      @ads = find_model.blank? ? Ads.create({type_ad: params[:id]}) : find_model
      # @back_url = edit_superuser_test_path(@question.test_id)
    end

    def update
      model = find_model
      model.update(params_model)
      redirect_to superuser_model_path
    end

    def remove
      find_model.destroy
      redirect_to :back
    end

    private

    def superuser_model_path
      "/superuser/ads"
    end

    def find_model
      Ads.find_by_type_ad(params[:id])
    end

    def params_model
      params.require(:ads).permit(:content, :title, :img, :href)
    end

  end
end
