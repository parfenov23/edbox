module Superuser
  class SectionsController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @sections = Section.all
    end

    def edit
      @section = Section.find(params[:id])
      @back_url = "/superuser/courses/#{@section.course_id}/edit"
    end

    def new
      @section = Section.new
      @back_url = "/superuser/courses/#{params[:course_id]}/edit"
    end

    def create
      section = Section.new(params_course)
      section.save
      redirect_to "/superuser/courses/#{section.course_id}/edit"
    end

    def update
      section = Section.find(params[:id])
      section.update(params_course)
      redirect_to "/superuser/courses/#{section.course_id}/edit"
    end

    def remove
      Section.find(params[:id]).destroy
      redirect_to :back
    end

    def params_course
      params.require(:sections).permit(:title, :course_id)
    end

  end
end
