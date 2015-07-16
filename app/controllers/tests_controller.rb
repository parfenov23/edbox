class TestsController < HomeController
  def run
    @test = find_test
    @course = @test.section.course
  end

  def complete
    test = find_test
    result = test.result(current_user.id, params[:answer])
    if result
      render json: result.as_json
    else
      render :error
    end
  end

  private

  def find_test
    Test.find(params[:id])
  end
end
