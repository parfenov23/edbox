xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Курсы ADCONSULT ONLINE"
    xml.description "Все курсы ADCONSULT ONLINE"
    xml.link "/courses/#{params[:type]}"

    for course in @courses
      xml.item do
        xml.title course.title
        cmaterial = course.material? || course.instrument?
        text = (cmaterial ? text_type_material[course.attachments.last.file_type] : (course.online? ? "Вебинар" : "Онлайн-курс") rescue 'Онлайн-курс')
        xml.type text
        if course.material? || course.instrument?
          if course.teaser.blank?
            src = "/assets/orange-waves.svg"
          else
            src = course.teaser.get_image_path(694, 384)
          end
        else
          src = course.get_image_path(694, 384)
        end
        xml.img $env_mode.current_domain + src
        xml.pubDate "Опубликовано: #{schedule_line[course.updated_at.month-1][:title]} #{course.updated_at.year}"
        xml.link "#{$env_mode.current_domain}/course_description/#{course.id}"
        # xml.guid post_url(post)
      end
    end
  end
end