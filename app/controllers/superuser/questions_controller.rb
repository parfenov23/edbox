module Superuser
  class QuestionsController < ActionController::Base
    layout "superuser"
    skip_before_action :authorize

    def index
      @questions = Question.where(test_id: params[:test_id])
    end

    def edit
      @question = find_question
      # @back_url = edit_superuser_test_path(@question.test_id)
    end

    def new
      @question = Question.new
      # @back_url = edit_superuser_test_path(params[:test_id])
    end

    def create
      question = Question.new(params_question)
      question.save
      redirect_to superuser_questions_path + "?test_id=#{question.test_id}"
    end

    def update
      question = find_question
      question.update(params_question)
      redirect_to superuser_questions_path + "?test_id=#{question.test_id}"
    end

    def remove
      find_question.destroy
      redirect_to :back
    end

    private

    def find_question
      Question.find(params[:id])
    end

    def params_question
      params.require(:questions).permit(:title, :test_id)
    end

  end
end
