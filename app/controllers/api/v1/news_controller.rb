module Api::V1
  class NewsController < ::ApplicationController

    def read
      news = find_news
      arr_users_id = news.users_id
      arr_users_id << current_user.id
      news.update(users_id: arr_users_id.sort.uniq)
      render json: {success: true}
    end

    private

    def find_news
      News.find(params[:id])
    end
  end

end
