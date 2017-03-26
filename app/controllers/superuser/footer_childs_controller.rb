module Superuser
  class FooterChildsController < SuperuserController

    def index
      @footer_childs = FooterChild.all
    end

    def edit
      @footer_child = find_footer_child
      # @footer_parent = @footer_child.footer_parent
    end

    def new
      @footer_child = FooterChild.new
    end

    def create
      footer_child = FooterChild.new(params_footer_child)
      footer_child.save
      redirect_to edit_superuser_footer_parent_path(footer_child.footer_parent_id, params: {error: "save"})
    end

    def update
      footer_child = find_footer_child
      footer_child.update(params_footer_child)
      redirect_to edit_superuser_footer_parent_path(footer_child.footer_parent_id, params: {error: "save"})
    end

    def remove
      find_footer_child.destroy
      redirect_to :back
    end

    private

    def find_footer_child
      FooterChild.find(params[:id])
    end

    def params_footer_child
      params.require(:footer_child).permit(:title, :href, :footer_parent_id).compact rescue {}
    end
  end
end
