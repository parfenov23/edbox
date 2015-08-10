module NavLinkHelper

  def menu_nav_links(type)
    case type
      when "courses"
        courses_nav_links
      when "group"
        group_nav_link
      when "programm"
        course_description_nav_links
      when "other_white", "other", "members", "schedule", "cabinet", "profile"
        other_nav_links
      when "my_course"
        my_course_nav_links
    end
  end

  def courses_nav_links
    []
  end

  def my_course_nav_links
    [
      {title: "Текущие", link: "/my_course?type=current"},
      {title: "Просроченные", link: "/my_course?type=overdue"},
      {title: "Назначенные", link: "/my_course?type=assigned"},
      {title: "Отложенные", link: "/my_course?type=favorite"}
    ]
  end


  def other_nav_links
    []
  end

  def group_nav_link
    if current_user.director
      current_user.company.groups.map do |group|
        {title: group.first_name, link: "/group?id=#{group.id}"}
      end
    elsif current_user.corporate
      current_user.my_groups.map do |group|
        {title: group.first_name, link: "/group?id=#{group.id}"}
      end
    end
  end

end