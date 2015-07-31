module Api::V1
  class CompaniesController < ::ApplicationController
    def info
      company = current_user.company
      if company.present?
        render json: company.transfer_to_json
      else
        render_error(500, 'Проверьте данные')
      end
    end
  end
end
