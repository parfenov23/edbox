module NavLinkHelper

  def menu_nav_links(type)
    case type
      when "courses"
        courses_nav_links
      when "group"
        group_nav_link
      when "programm"
        course_description_nav_links
      when "other_white", "other", "members", "schedule", "cabinet"
        other_nav_links
      when "my_course"
        my_course_nav_links
      when "contenter_courses_new"
        contenter_courses_new_nav_links
      when "contenter_materials_new"
        contenter_materials_new_nav_links
      when "contenter_admin"
        contenter_admin_nav_links
      when "profile"
        profile_nav_links
      else
        other_nav_links
    end
  end

  def courses_nav_links
    []
  end

  def profile_nav_links
    if (!current_user.corporate?) || (current_user.director)
      [
        { title: "Профиль", link: "/profile" },
        { title: "Тариф", link: "/tariff" }
      ]
    else
      [
        { title: "Профиль", link: "/profile" },
      ]
    end
  end

  def contenter_admin_nav_links
    [
      {title: "Категории", link: "/contenter/admin/categories"},
      {title: "Теги", link: "/contenter/admin/tags"},
      {title: "Ведущие", link: "/contenter/admin/members"}
    ]
  end

  def contenter_materials_new_nav_links
    id = params[:id].present? ? params[:id] : "new"
    [
      {title: "Описание", link: "/contenter/materials/#{id}/edit"},
      {title: "Публикация", link: "/contenter/materials/#{id}/publication"}
    ]
  end

  def contenter_courses_new_nav_links
    id = params[:id].present? ? params[:id] : "new"
    course_validate = Course.find(params[:id]).validate rescue {}
    desc_valid = course_validate.select{|k, v| k == :description && v == false}.present? ? "error" : ""
    prog_valid = course_validate.select{|k, v| k == :program && v == false}.present? ? "error" : ""
    type_course = params[:type_course].present? ? "?type_course=#{params[:type_course]}" : ""
    [
      {title: "Описание", link: "/contenter/courses/#{id}/edit#{type_course}",
       add_params: {class: "contenter_courses_edit #{desc_valid}"}
      },
      {title: "Программа", link: "/contenter/courses/#{id}/program#{type_course}",
       add_params: {class: "contenter_courses_programm #{prog_valid}"}
      },
      {title: "Публикация", link: "/contenter/courses/#{id}/publication#{type_course}",
       add_params: {class: "contenter_courses_public"}}
    ]
  end

  def my_course_nav_links
    [
      {title: "Текущие", link: "/my_course?type=current"},
      {title: "Просроченные", link: "/my_course?type=overdue"},
      {title: "Назначенные", link: "/my_course?type=assigned"},
      {title: "Избранное", link: "/my_course?type=favorite"}
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