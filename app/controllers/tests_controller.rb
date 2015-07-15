class TestsController < ApplicationController
  def run
    @test = find_test
    @course = @test.section.course
  end

  def complete
    test = Test.find(params[:test_id])
    binding.pry
    if test.result(current_user.id, params[:answer])
      render json: {success: true}
    end
  end

  private

  def current_user
    @current_user = User.find_by(email: 'testvasser@mail.ru')
    @current_user
  end

  def find_test
    Test.find(params[:id])
  end
end
