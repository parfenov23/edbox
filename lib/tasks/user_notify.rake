namespace :user_notify do
  desc "TODO"
  task :new_course, [:course] => :environment do |t, args|
    auth_users = User.where.not(last_auth: nil)
    (auth_users.where(corporate: false) + auth_users.where(director: true)).each do |user|
      course = Course.find(args[:course])
      user.create_notify(course, 'new')
    end
  end
  task :remove_course, [:course, :group] => :environment do |t, args|
    bunch_groups = Group.find(args[:group]).bunch_groups
    bunch_groups.each do |bunch_group|
      user = bunch_group.user
      course = Course.find(args[:course])
      user.create_notify(course, 'remove')
    end
  end

  task overdue_course: :environment do
    User.all.each do |user|
      user.bunch_courses.overdue.each do |bunch_course|
        user.create_notify(bunch_course, 'overdue_course')
      end
    end
  end

  task close_overdue_course: :environment do
    User.all.each do |user|
      current_time = Time.now
      user.bunch_courses.where(date_complete: current_time.beginning_of_day..current_time.end_of_day).each do |bunch_course|
        user.create_notify(bunch_course, 'close_overdue_course')
      end
    end
  end

end
