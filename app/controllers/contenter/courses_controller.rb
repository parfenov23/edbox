module Contenter
  class CoursesController < HomeController
    before_action :authorize
    helper_method :current_user
    before_action :is_contenter?
    layout "application"

    def index
      @courses = Course.all
    end

    def edit
    end

    def program
      if params[:id] != 'new'
        redirect_to publication_contenter_course_path(id: params[:id]) if find_course.public
      end
    end

    def publication
      begin
        @course = find_course
      rescue
        redirect_to "contenter/courses/new/edit"
      end
    end

    private

    def find_course
      Course.find(params[:id])
    end

  end
end
