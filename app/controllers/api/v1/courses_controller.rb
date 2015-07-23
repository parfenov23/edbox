module Api::V1
  class CoursesController < ::ApplicationController

    def show
      render json: find_course.as_json(include: :sections)
    end

    private

    def find_course
      Course.find(params[:id])
    end
  end

end
