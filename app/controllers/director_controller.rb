class DirectorController < HomeController
  def statistic
    @groups = find_groups
    current_group = params[:group_id].present? ? @groups.where(id: params[:group_id]) : @groups
    @users = current_group.all_users
    @courses = current_group.all_courses
  end

  def csv
    groups = find_groups
    current_group = params[:group] != 'all' ? groups.where(id: params[:group_id]) : groups
    users = current_group.all_users
    courses = current_group.all_courses
    path = path_file
    CSV.open(path, "wb") do |csv|
      csv << [""] + courses.map(&:title)
      users.each do |user|
        statistics = courses.map{|course| user.statistic(course, "group", true)[:course]}
        csv << [user.full_name] + statistics
      end
    end

    send_file(path, :type => "text/csv; charset=utf-8")
  end

  private

  def find_groups
    current_user.all_groups
  end

  def path_file
    path = Rails.root.to_s + "/public/system/statistic/#{current_user.id}/#{Time.current.to_i}.csv"
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    path
  end
end
