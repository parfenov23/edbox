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

    def add_leading
      course = find_course
      ligament_leading = course.ligament_leads.find_or_create_by({user_id: params[:leading_id]})
      render json: ligament_leading.user.transfer_to_json
    end

    def remove_leading
      course = find_course
      ligament_leading = course.ligament_leads.where({user_id: params[:leading_id]}).last
      user = ligament_leading.user.transfer_to_json
      ligament_leading.destroy
      render json: user
    end

    def update_type
      course = find_course
      account_type = AccountTypeRelation.new({modelable_id: course.id, modelable_type: "Course"})
      account_type.account_type_id = params[:account_type_id]
      account_type.save
      course.update({account_type_id: params[:account_type_id]});
      render json: {success: true}
    end

    private

    def find_course
      Course.find(params[:id])
    end

    def params_course
      params.require(:course).permit(:title, :description, :img, :user_id, :duration, :public).compact.select { |k, v| v != "" } rescue {}
    end
  end

end
