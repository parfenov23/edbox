module Api::V1
  class CoursesController < ::ApplicationController

    def show
      render json: find_course.as_json(include: :sections)
    end

    def all
      all_courses = Course.all.map(&:transfer_to_json)
      render json: all_courses
    end

    def info
      render json: find_course.transfer_to_json
    end

    private

    def find_course
      Course.find(params[:id])
    end
  end

end
