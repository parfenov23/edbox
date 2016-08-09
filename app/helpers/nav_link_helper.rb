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
      when "contenter_instruments_new"
        contenter_materials_new_nav_links("instruments")
      when "contenter_admin"
        contenter_admin_nav_links
      when "profile"
        profile_nav_links
      else
        other_nav_links
    end
  end

  def courses_nav_links
    [
      {title: "Все вместе", link: "/courses"},
      {title: "Онлайн-курсы", link: "/courses/course", type: "course"},
      {title: "Вебинары", link: "/courses/online", type: "online"},
      {title: "Справочные материалы", link: "/courses/material", type: "material"},
      {title: "Инструменты продаж", link: "/courses/instrument", type: "instrument"}
    ]
  end

  def profile_nav_links
    [
      {title: "Профиль", link: "/profile"},
      {title: "Тариф", link: "/tariff"},
      {title: "Платежи", link: "/payments"},
      {title: "Публичная страница", link: "/user/#{current_user.id}"}
    ]
  end

  def contenter_admin_nav_links
    [
      {title: "Категории", link: "/contenter/admin/categories"},
      {title: "Теги", link: "/contenter/admin/tags"},
      {title: "Ведущие", link: "/contenter/admin/members"}
    ]
  end

  def contenter_materials_new_nav_links(type="materials")
    id = params[:id].present? ? params[:id] : "new"
    [
      {title: "Описание", link: "/contenter/#{type}/#{id}/edit",
       add_params: {class: "contenter_courses_edit"}
      },
      {title: "Публикация", link: "/contenter/#{type}/#{id}/publication",
       add_params: {class: "contenter_courses_public"}
      }
    ]
  end

  def contenter_courses_new_nav_links
    id = params[:id].present? ? params[:id] : "new"
    course = id == 'new' ? nil : Course.find(params[:id])
    course_validate = course.validate rescue {}
    desc_valid = course_validate.select { |k, v| k == :description && v == false }.present? ? "error" : ""
    prog_valid = course_validate.select { |k, v| k == :program && v == false }.present? ? "error" : ""
    type_course = params[:type_course].present? ? "?type_course=#{params[:type_course]}" : ""
    disable = course.public ? "disable" : nil rescue nil
    [
      {title: "Описание", link: "/contenter/courses/#{id}/edit#{type_course}",
       add_params: {class: "contenter_courses_edit #{desc_valid}"}
      },
      {title: "Программа", link: "/contenter/courses/#{id}/program#{type_course}",
       add_params: {class: "contenter_courses_programm #{prog_valid} #{disable}"}
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

  def back_url_course
    begin
      go_to_back_url = back_url
      if !back_url.scan("/cabinet").present? || !back_url.scan("/courses").present?
        session[:histories].reverse.each do |url|
          if url.scan("/cabinet").present? || url.scan("/courses").present?
            go_to_back_url = url
            break
          end
        end
      end
      go_to_back_url
    rescue
      "/courses"
    end
  end

  def back_url
    session[:back_url] rescue "/cabinet"
  end

  def group_nav_link
    if current_user.director
      current_user.company.groups.map do |group|
        {title: group.first_name, link: "/group/#{group.id}"}
      end
    elsif current_user.corporate
      current_user.my_groups.map do |group|
        {title: group.first_name, link: "/group/#{group.id}"}
      end
    end
  end

end