module Superuser
  class CoursesController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @courses = Course.all
    end

    def edit
      @course = find_course
      @tags = Tag.all
    end

    def new
      @course = Course.new
      @tags = Tag.all
    end

    def create
      course = Course.new(params_course)
      course.save
      redirect_to edit_superuser_course_path(course.id)
    end

    def update
      course = find_course
      course.update(params_course)
      course.bunch_tags.destroy_all
      course.bunch_tags.create(params[:tags].map { |t| {tag_id: t} })
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
      params.require(:course).permit(:title, :description, :img, :user_id, :duration)
    end

  end
end
