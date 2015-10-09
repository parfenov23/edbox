module Superuser
  class CompaniesController < SuperuserController

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
      redirect_to edit_superuser_company_path(company.id)
    end

    def update
      company = find_company
      company.update({first_name: params[:first_name]})
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
