module Superuser
  class AskQuestionsController < SuperuserController

    def index
      @ask_questions = AskQuestion.all
    end

    def edit
      @ask_question = find_ask_questions
    end

    def new
      @ask_question = AskQuestion.new
    end

    def create
      ask_question = AskQuestion.new(params_ask_questions)
      ask_question.save
      redirect_to edit_superuser_ask_question_path(ask_question.id)
    end

    def update
      ask_question = find_ask_questions
      ask_question.update(params_ask_questions)
      redirect_to :back
    end

    def remove
      find_ask_questions.destroy
      redirect_to :back
    end

    private

    def find_ask_questions
      AskQuestion.find(params[:id])
    end

    def params_ask_questions
      params.require(:ask_question).permit(:title, :description).compact rescue {}
    end
  end
end
