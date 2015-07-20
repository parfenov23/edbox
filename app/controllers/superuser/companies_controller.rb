module Superuser
  class CompaniesController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @companies = Company.all
    end

    def edit
      @company = find_company
    end

    def new
      @company = Company.new
    end

    def create
      company = Company.new({first_name: params[:first_name]})
      company.save
      company.update_account_type(params[:account_type].to_i)
      redirect_to edit_superuser_company_path(company.id)
    end

    def update
      company = find_company
      company.update({first_name: params[:first_name]})
      company.update_account_type(params[:account_type].to_i)
      redirect_to :back
    end

    def remove
      find_company.destroy
      redirect_to :back
    end

    private

    def find_company
      Company.find(params[:id])
    end
  end
end
