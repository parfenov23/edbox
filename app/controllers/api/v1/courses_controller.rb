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

    def create
      course = Course.new(params_course)
      course.save
      render json: course.transfer_to_json
    end

    def update
      course = find_course
      course.update(params_course)
      render json: course.transfer_to_json
    end

    def add_tag
      course = find_course
      bunch_tag = course.bunch_tags.find_or_create_by({tag_id: params[:tag_id]})
      render json: bunch_tag.tag.as_json
    end

    def remove_tag
      course = find_course
      bunch_tag = course.bunch_tags.where({tag_id: params[:tag_id]}).last
      tag = bunch_tag.tag.as_json
      bunch_tag.destroy
      render json: tag.as_json
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
