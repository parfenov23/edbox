class TestsController < HomeController
  def run
    @test = find_test
    section = @test.section
    @course = section.course
    bunch_section = section.bunch_section(current_user.id)
    unless bunch_section.present?
      redirect_to '/'
    end
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

  def result
    @test = find_test
    section = @test.section
    @course = section.course
    bunch_section = section.bunch_section(current_user.id)
    unless bunch_section.present?
      redirect_to '/'
    end
  end

  private

  def find_test
    Test.find(params[:id])
  end
end
