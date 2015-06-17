module Superuser
  class GroupsController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @group = Group.all
    end

    def edit
      @group = Group.find(params[:id])
    end

    def new
      @group = Group.new
    end

    def create
      group = Group.new(params_group)
      group.save
      redirect_to "/superuser/groups/#{group.id}/edit"
    end

    def update
      Group.find(params[:id]).update(params_group)
      redirect_to :back
    end

    def remove
      Group.find(params[:id]).users.each do |user|
        user.group_id = nil
        user.save
      end
      Group.find(params[:id]).destroy
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

    def params_group
      {first_name: params[:first_name], company_id: params[:company_id]}
    end

  end
end
