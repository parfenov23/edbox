module Api::V1
  class NewsController < ::ApplicationController

    def read
      arr_users_id = (find_news.users_id << current_user.id)
      find_news.update(users_id: arr_users_id.sort.uniq)
      render json: {success: true}
    end

    private

    def find_news
      News.find(params[:id])
    end
  end

end
