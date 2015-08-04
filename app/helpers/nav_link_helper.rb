module NavLinkHelper

  def menu_nav_links(type)
    case type
      when "cabinet"
        cabinet_nav_links
      when "courses"
        courses_nav_links
      when "group"
        group_nav_link
      when "course_description"
        course_description_nav_links
      when "programm"
        course_description_nav_links
      when "profile"
        profile_nav_links
      when "video"
        video_nav_links
    end
  end

  def courses_nav_links
    []
  end

  def profile_nav_links
    []
  end

  def video_nav_links
    []
  end

  def course_description_nav_links
    [{title: "Описание", link: "/course_description?id=#{params[:id]}"},
     {title: "Программа", link: "/programm?id=#{params[:id]}"}]
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

  def cabinet_nav_links
    if current_user.director
      [{title: "Группы", link: "/group"},
       {title: "Участники", link: "/members"},
       {title: "Расписание", link: "/schedule"},
       {title: "Мои курсы", link: "/my_course?type=favorite"}]
    elsif current_user.corporate
      [{title: "Группы", link: "/group"},
       {title: "Расписание", link: "/schedule"},
       {title: "Мои курсы", link: "/my_course?type=favorite"}]
    elsif !current_user.corporate
      [{title: "Расписание", link: "/schedule"},
       {title: "Мои курсы", link: "/my_course?type=favorite"}]
    end
  end

end