class HomeController < ActionController::Base
  layout "application"
  def show
    render :text => "profile"
  end

  def profile
  end
end
