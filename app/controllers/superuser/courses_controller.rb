require 'resize_image'
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
      create_all_img(params[:image], course.id) if params[:image]
      redirect_to edit_superuser_course_path(course.id)
    end

    def update
      find_course.update(params_course)
      current_course = Course.find(params[:id])
      create_all_img(params[:image], current_course.id) if params[:image]
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

    def create_all_img(image, id)
      attachment = Attachment.save_file('Course', id, image, 'full')
      attachment_img = MiniMagick::Image.open(attachment.file.path)
      tumb1 = ResizeImage.edresize(attachment_img, 347, 192)
      Attachment.save_file('Course', id, tumb1, '347x192')
      tumb2 = ResizeImage.edresize(attachment_img, 920, 377)
      Attachment.save_file('Course', id, tumb2, '920x377')
    end
  end
end
