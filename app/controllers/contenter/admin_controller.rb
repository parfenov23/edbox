module Contenter
  class AdminController < HomeController
    before_action :authorize
    helper_method :current_user
    before_action :is_contenter?
    layout "application"

    def members
      @members = User.where(leading: true)
    end

    def tags
      @tags = Tag.all
      if @tags.blank?
        Tag.create
        @tags = Tag.all
      end
    end

    def categories
      @categories = Category.all
      if @categories.blank?
        Category.create
        @categories = Category.all
      end
    end

  end
end
