module Api::V1
  class TestsController < ::ApplicationController
    require 'resize_image'

    def get_test
      test = find_test
      render json: test.transfer_to_json
    end

    def result
      test = find_test
      result = test.result(current_user.id, params[:answer])
      if result
        json_hash = result.as_json
        json_hash[:course_id] = test.testable.id
        json_hash[:course_name] = test.testable.title
        json_hash[:certificate] = result.result == 100 ? test.certificate(current_user) : false
        render json: json_hash
      else
        render json: {success: false}
      end
    end

    def remove
      find_test.destroy
      render json: {success: false}
    end

    def create
      test = Test.find_or_create_by(test_params)
      test.build_default if test.questions.count == 0
      if params[:type] == "html"
        file_name = !params[:file_name].present? ? "_test" : params[:file_name]
        html_result = render_to_string "contenter/courses/program/#{file_name}", :layout => false,
                                       :locals => {test: test}
        render text: html_result
      else
        render json: test.transfer_to_json
      end
    end

    def certificate
      result = find_test.certificate(current_user)
      render html: "<img src='#{result}' style='width:1100px;'/>".html_safe
    end

    def update
      test = find_test
      test.update(test_params)
      render json: test.transfer_to_json
    end

    private

    def test_params
      params.require(:test).permit(:testable_id, :testable_type, :title).compact.select { |k, v| v != "" } rescue {}
    end

    def find_test
      Test.find(params[:id])
    end
  end
end
