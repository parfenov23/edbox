module Superuser
  class TagsController < SuperuserController

    def index
      @tags = Tag.where(tagtable_type: "parent")
    end

    def edit
      @tag = find_tag
      @back_url = superuser_tags_path
    end

    def new
      @tag = Tag.new({tagtable_type: "parent"})
      @back_url = superuser_tags_path
    end

    def create
      create_tag = Tag.new(params_tag)
      create_tag.save
      redirect_url = create_tag.tagtable_type == "parent" ? superuser_tags_path : subtag_superuser_tag_path(create_tag.tagtable_id)
      redirect_to redirect_url
    end

    def update
      find_tag.update(params_tag)
      redirect_to :back
    end

    def remove
      find_tag.destroy
      redirect_to :back
    end

    def subtag
      @type = params[:type].present? ? params[:type] : "index"
      @parent_tag = find_tag
      case @type
        when "index"
          @tags = @parent_tag.tags
        when "new"
          subtag_new
      end
    end

    def subtag_new
      @tag = Tag.new({tagtable_type: "Tag", tagtable_id: find_tag.id})
    end

    private

    def find_tag
      Tag.find(params[:id])
    end

    def find_subtag

    end

    def params_tag
      params.require(:tag).permit(:title, :tagtable_id, :tagtable_type)
    end

  end
end
