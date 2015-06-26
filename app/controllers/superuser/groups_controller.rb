module Superuser
  class GroupsController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @group = Group.all
    end

    def edit
      @group = find_group
      @back_url = (edit_superuser_company_path(params[:company_id], params: {type: 'group'}) rescue nil)
    end

    def new
      @group = Group.new
      @back_url = edit_superuser_company_path(params[:company_id], params: {type: 'group'})
    end

    def create
      group = Group.new(params_group)
      group.save
      redirect_to edit_superuser_group_path(group.id, params:{company_id: group.company_id})
    end

    def update
      Group.find(params[:id]).update(params_group)
      redirect_to :back
    end

    def remove
      group = find_group
      group.users.each do |user|
        user.group_id = nil
        user.save
      end
      group.destroy
      redirect_to :back
    end

    def add_user
      bunch_group = BunchGroup.build(params[:user_id], params[:id])
      bunch_group.save
      redirect_to :back
    end

    def remove_user
      user = User.find(params[:user_id])
      user.bunch_groups.where(group_id: params[:id]).destroy_all
      redirect_to :back
    end

    def add_course
      @group = find_group
      @bunch_course = BunchCourse.new
    end

    def update_course
      render :text => "Метод в разработке"
    end

    private

    def find_group
      Group.find(params[:id])
    end

    def params_group
      {first_name: params[:first_name], company_id: params[:company_id]}
    end

  end
end
