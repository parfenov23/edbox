module Superuser
  class NewsController < SuperuserController

    def index
      @news_all = News.all
    end

    def edit
      @news = find_news
    end

    def new
      @news = News.new
    end

    def create
      news = News.new(params_news)
      news.save
      redirect_to edit_superuser_news_path(news.id, params: {error: "save"})
    end

    def update
      news = find_news
      news.update(params_news)
      redirect_to :back
    end

    def remove
      find_news.destroy
      redirect_to :back
    end

    private

    def find_news
      News.find(params[:id])
    end

    def params_news
      params.require(:news).permit(:title, :description).compact rescue {}
    end
  end
end
