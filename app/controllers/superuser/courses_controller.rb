module Superuser
  class CoursesController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @courses = Course.all
    end

    def edit
      @course = find_course
    end

    def new
      @course = Course.new
    end

    def create
      course = Course.new(params_course)
      course.save
      redirect_to edit_superuser_course_path(course.id)
    end

    def update
      find_course.update(params_course)
      redirect_to :back
    end

    def remove
      find_course.destroy
      redirect_to :back
    end

    private

    def find_course
      Course.find(params[:id])
    end

    def params_course
      params.require(:course).permit(:title, :description, :img)
    end

  end
end
