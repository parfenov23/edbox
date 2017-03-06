module Api::V1
  class CoursesController < ::ApplicationController

    def show
      render json: find_course.as_json(include: :sections)
    end

    def all
      all_courses = Course.all.map { |course| course.transfer_to_json_mini((current_user.id rescue nil)) }
      render json: all_courses
    end

    def info
      render json: find_course.transfer_to_json((current_user.id rescue nil))
    end

    def attachments
      render json: (find_course.attachments.last.transfer_to_json rescue {})
    end

    def create
      course = Course.new(params_course)
      course.save
      render json: course.transfer_to_json
    end

    def update
      course = find_course
      course.update(params_course.merge({og: params[:course][:og]}).compact)
      course.notice_users
      if course.online?
        course.sections.attachments.webinars.each do |webinar|
          webinar.eventUpdate
        end
      end
      render json: course.transfer_to_json
    end

    def add_tag
      course = find_course
      bunch_tag = course.bunch_tags.find_or_create_by({tag_id: params[:tag_id]})
      render json: bunch_tag.tag.as_json
    end

    def update_teaser_material
      course = find_course
      teaser = course.teaser || Teaser.create({course: course})
      attachment = teaser.attachment || Attachment.new
      attachment = attachment.update_file(teaser, params[:file])
      attachment.update({size: 'full', file_type: 'image'})
      teaser.update({attachment_id: attachment.id})
      render json: attachment.transfer_to_json
    end

    def remove_teaser_material
      course = find_course
      course.teaser.destroy
      render json: {success: true}
    end

    def add_category
      course = find_course
      course.bunch_categories.destroy_all
      bunch_category = course.bunch_categories.create({category_id: params[:category_id]})
      render json: bunch_category.category.as_json
    end

    def remove_tag
      course = find_course
      bunch_tag = course.bunch_tags.where({tag_id: params[:tag_id]}).last
      tag = bunch_tag.tag.as_json
      bunch_tag.destroy
      render json: tag.as_json
    end

    def remove_category
      course = find_course
      bunch_category = course.bunch_categories.where({category_id: params[:category_id]}).last
      category = bunch_category.category.as_json
      bunch_category.destroy
      render json: category.as_json
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
      course.update({paid: params[:type]})
      render json: {success: true}
    end

    def update_teaser
      course = find_course
      course.attachments.where(file_type: params[:type_teaser]).destroy_all
      size = params[:type_teaser] == "image" ? "full" : nil
      attachment = Attachment.save_file('Course', course.id, params[:file], size)
      render json: attachment.transfer_to_json
    end

    def remove_teaser
      course = find_course
      course.attachments.where(file_type: params[:type]).destroy_all
      render json: {success: true}
    end

    def complete_material
      course = find_course
      bunch_courses = course.bunch_courses.where(user_id: current_user.id)
      bunch_courses.update_all({complete: true})
      render json: {success: true}
    end

    def remove
      # find_course.destroy
      find_course.update(archive: true)
      render json: {success: true}
    end

    private

    def find_course
      Course.find(params[:id])
    end

    def params_course
      params.require(:course).permit(:title, :description, :img, :user_id, :duration, :public, :type_course, :announcement_date).compact rescue {}
    end
  end

end
