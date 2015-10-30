class SuperuserController < HomeController
  include ApplicationHelper
  layout "superuser"
  before_action :is_superuser?

  private

  def is_superuser?
    redirect_to "/" unless current_user.superuser
  end
end