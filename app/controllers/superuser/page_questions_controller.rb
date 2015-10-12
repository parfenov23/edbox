module Superuser
  class PageQuestionsController < SuperuserController

    def index
      @page_questions = PageQuestion.all
    end

    def edit
      @page_question = find_page_questions
    end

    def new
      @page_question = PageQuestion.new
    end

    def create
      page_question = PageQuestion.new(params_page_questions)
      page_question.save
      redirect_to edit_superuser_page_question_path(page_question.id)
    end

    def update
      page_question = find_page_questions
      page_question.update(params_page_questions)
      redirect_to :back
    end

    def remove
      find_page_questions.destroy
      redirect_to :back
    end

    private

    def find_page_questions
      PageQuestion.find(params[:id])
    end

    def params_page_questions
      params.require(:page_question).permit(:title, :content, :ask_question_id).compact rescue {}
    end
  end
end
