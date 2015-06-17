module Superuser
  class CompaniesController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @companies = Company.all
    end

    def edit
      @company = Company.find(params[:id])
    end

    def new
      @company = Company.new
    end

    def create
      company = Company.new({first_name: params[:first_name]})
      company.save
      redirect_to "/superuser/companies/#{company.id}/edit"
    end

    def update
      Company.find(params[:id]).update({first_name: params[:first_name]})
      redirect_to :back
    end

    def remove
      Company.find(params[:id]).users.destroy_all
      Company.find(params[:id]).groups.destroy_all
      Company.find(params[:id]).destroy
      redirect_to :back
    end
  end
end
