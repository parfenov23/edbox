module Superuser
  class TestsController < ActionController::Base
    layout "superuser"

    def index
      @tests = Test.where(section_id: params[:section_id])
    end

    def show
      @tests = Test.all
      render :index
    end

    def edit
      @test = find_test
      # @back_url = edit_superuser_course_path(@section.course_id)
    end

    def new
      @test = Test.new
      # @back_url = edit_superuser_course_path(params[:course_id])
    end

    def create
      test = Test.new(params_test)
      test.save
      redirect_to superuser_tests_path + "?section_id=#{test.section_id}"
    end

    def update
      test = find_test
      test.update(params_test)
      redirect_to superuser_tests_path + "?section_id=#{test.section_id}"
    end

    def remove
      find_test.destroy
      redirect_to :back
    end

    private

    def find_test
      Test.find(params[:id])
    end

    def params_test
      params.require(:tests).permit(:title, :section_id)
    end

  end
end
