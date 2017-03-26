module Superuser
  class FooterParentsController < SuperuserController

    def index
      @footer_parents = FooterParent.all
    end

    def edit
      @footer_parent = find_footer_parent
      @footer_childs = @footer_parent.footer_childs
    end

    def new
      @footer_parent = FooterParent.new
    end

    def create
      footer_parent = FooterParent.new(params_footer_parent)
      footer_parent.save
      redirect_to edit_superuser_footer_parent_path(footer_parent.id, params: {error: "save"})
    end

    def update
      footer_parent = find_footer_parent
      footer_parent.update(params_footer_parent)
      redirect_to :back
    end

    def remove
      find_footer_parent.destroy
      redirect_to :back
    end

    private

    def find_footer_parent
      FooterParent.find(params[:id])
    end

    def params_footer_parent
      params.require(:footer_parent).permit(:title).compact rescue {}
    end
  end
end
