module Superuser
  class AnswersController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @answers = Answer.where(question_id: params[:question_id])
    end

    def edit
      @answer = find_answer
      # @back_url = edit_superuser_test_path(@question.test_id)
    end

    def new
      @answer = Answer.new
      # @back_url = edit_superuser_test_path(params[:test_id])
    end

    def create
      answer = Answer.new(params_answer)
      answer.save
      redirect_to superuser_answers_path + "?question_id=#{answer.question_id}"
    end

    def update
      answer = find_answer
      # binding.pry
      answer.update(params_answer)
      redirect_to superuser_answers_path + "?question_id=#{answer.question_id}"
    end

    def remove
      find_answer.destroy
      redirect_to :back
    end

    private

    def find_answer
      Answer.find(params[:id])
    end

    def params_answer
      params.require(:answer).permit(:text, :question_id, :right)
    end

  end
end
