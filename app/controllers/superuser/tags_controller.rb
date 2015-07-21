module Superuser
  class TagsController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @tags = Tag.all
    end

    def edit
      @tag = find_tag
      @back_url = superuser_tags_path
    end

    def new
      @tag = Tag.new
      @back_url = superuser_tags_path
    end

    def create
      Tag.new(params_tag).save
      redirect_to superuser_tags_path
    end

    def update
      find_tag.update(params_tag)
      redirect_to :back
    end

    def remove
      find_tag.destroy
      redirect_to :back
    end

    private

    def find_tag
      Tag.find(params[:id])
    end

    def params_tag
      params.require(:tag).permit(:title)
    end

  end
end
