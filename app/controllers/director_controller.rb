class DirectorController < HomeController
  def statistic
    @groups = current_user.all_groups
    current_group = params[:group_id].present? ? @groups.where(id: params[:group_id]) : @groups
    @users = current_group.all_users
    @courses = current_group.all_courses
  end
end
