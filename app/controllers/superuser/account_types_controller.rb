module Superuser
  class AccountTypesController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @account_types = AccountType.all
    end

    def edit
      @account_type = find_account_type
    end

    def new
      @account_type = AccountType.new
    end

    def create
      account_type = AccountType.new(params_account_type)
      account_type.save
      redirect_to edit_superuser_course_path(account_type.id)
    end

    def update
      account_type = find_account_type
      account_type.update(params_account_type)
      redirect_to :back
    end

    def remove
      find_account_type.destroy
      redirect_to :back
    end

    private

    def find_account_type
      AccountType.find(params[:id])
    end

    def params_account_type
      params.require(:account_type).permit(:name)
    end
  end
end
