module Superuser
  class CoursesController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @courses = Course.all
    end

    def edit
      @course = Course.find(params[:id])
    end

    def new
      @course = Course.new
    end

    def create
      course = Course.new(params_course)
      course.save
      redirect_to "/superuser/courses/#{course.id}/edit"
    end

    def update
      Course.find(params[:id]).update(params_course)
      redirect_to :back
    end

    def remove
      Course.find(params[:id]).destroy
      redirect_to :back
    end

    def params_course
      params.require(:course).permit(:title, :description, :img)
    end

  end
end
