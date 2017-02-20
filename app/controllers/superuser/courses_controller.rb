require 'resize_image'
module Superuser
  class CoursesController < SuperuserController

    def index
      @courses = params[:type].blank? ? Course.all : Course.webinars
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
      course.push_if_create
      # course.create_all_img(params[:image]) if params[:image]
      if params[:image]
        course.attachments.where(file_type: 'image').destroy_all
        Attachment.save_file('Course', course.id, params[:image], 'full')
      end
      redirect_to edit_superuser_course_path(course.id)
    end

    def update
      course = find_course
      course.update(params_course)
      course.bunch_tags.destroy_all
      course.bunch_tags.create((params[:tags].map { |t| {tag_id: t} } rescue []) )
      # course.create_all_img(params[:image]) if params[:image]
      if params[:image]
        course.attachments.where(file_type: 'image').destroy_all
        Attachment.save_file('Course', course.id, params[:image], 'full')
      end
      redirect_to :back
    end

    def remove
      find_course.update(archive: true)
      redirect_to :back
    end

    def un_remove
      Course.unscoped.find(params[:id]).destroy
      redirect_to "/superuser/courses/archive"
    end

    def archive
      @courses = Course.unscoped.where(archive: true)
    end

    def un_archive
      Course.unscoped.find(params[:id]).update(archive: false)
      redirect_to "/superuser/courses/archive"
    end

    private

    def find_course
      Course.find(params[:id])
    end

    def params_course
      params.require(:course).permit(:title, :description, :img, :user_id, :duration, :paid, :updated_at).compact rescue {}
    end
  end
end
