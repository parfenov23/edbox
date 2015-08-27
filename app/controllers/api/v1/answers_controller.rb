module Api::V1
  class AnswersController < ::ApplicationController

    def update
      question = find_answer
      question.update(answer_params)
      render json: question.transfer_to_json
    end

    def create
      answer = Answer.new(answer_params)
      answer.save
      if params[:type] == "html"
        html_result = render_to_string "contenter/courses/program/_answer", :layout => false,
                                       :locals => {answer: answer,
                                                   question: answer.question,
                                                   test: answer.question.test}
        render text: html_result
      else
        render json: answer.transfer_to_json
      end
    end

    def remove
      find_answer.destroy
      render json: {success: true}
    end

    private

    def answer_params
      params.require(:answer).permit(:text, :question_id, :right).compact.select { |k, v| v != "" } rescue {}
    end

    def find_answer
      Answer.find(params[:id])
    end

  end
end
