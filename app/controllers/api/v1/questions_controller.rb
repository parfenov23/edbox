module Api::V1
  class QuestionsController < ::ApplicationController

    def update
      question = find_question
      question.update(question_params)
      render json: question.transfer_to_json
    end

    def create
      question = Question.create(question_params)
      question.build_default
      if params[:type] == "html"
        html_result = render_to_string "contenter/courses/program/_question", :layout => false,
                                       :locals => {test: question.test, question: question}
        render text: html_result
      else
        render json: question.transfer_to_json
      end
    end

    def remove
      find_question.destroy
      render json: {success: true}
    end

    private

    def question_params
      params.require(:question).permit(:title, :test_id).compact.select { |k, v| v != "" } rescue {}
    end

    def find_question
      Question.find(params[:id])
    end

  end
end
