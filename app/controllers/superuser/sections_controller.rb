module Superuser
  class SectionsController < SuperuserController

    def index
      @sections = Section.all
    end

    def edit
      @section = find_section
      @back_url = edit_superuser_course_path(@section.course_id)
    end

    def new
      @section = Section.new
      @back_url = edit_superuser_course_path(params[:course_id])
    end

    def create
      section = Section.new(params_section)
      section.save
      redirect_to edit_superuser_course_path(section.course_id)
    end

    def update
      section = find_section
      section.update(params_section)
      redirect_to edit_superuser_course_path(section.course_id)
    end

    def remove
      find_section.destroy
      redirect_to :back
    end

    private

    def find_section
      Section.find(params[:id])
    end

    def params_section
      params.require(:sections).permit(:title, :course_id).compact rescue {}
    end

  end
end
