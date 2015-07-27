module Api::V1
  class CompaniesController < ::ApplicationController
    def info
      render json: (current_user.company.transfer_to_json rescue render_error(500, 'Проверьте данные'))
    end
  end
end
