module Api::V1
  class TestsController < ::ApplicationController
    def get_test
      test = find_test
      render json: test.transfer_to_json
    end

    def result
      test = find_test
      result = test.result(current_user.id, params[:answer])
      if result
        render json: result.as_json
      else
        render json: {success: false}
      end
    end

    private

    def find_test
      Test.find(params[:id])
    end
  end
end
