module Api::V1
  class SectionsController < ::ApplicationController

    def update
      section = find_section
      section.update(params_section)
      render json: section.transfer_to_json
    end

    def create
      section = Section.create(params_section)
      section.install_position
      render json: section.transfer_to_json
    end

    def contenter_html
      section = find_section
      section_html = render_to_string "contenter/courses/program/_section", :layout => false, :locals => {section: section, course: section.course}
      render text: section_html
    end

    def remove
      find_section.destroy
      render json: {success: true}
    end

    private

    def find_section
      Section.find(params[:id])
    end

    def params_section
      params.require(:section).permit(:title, :course_id) rescue {}
    end

  end
end
