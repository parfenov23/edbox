require 'calendar'
class SchedulesController < HomeController
  def index
    @current_user = current_user
    unless @current_user.corporate? && @current_user.director?
      return render '/home/error'
    end

    @today = DateTime.now
    @today = params[:date].to_date if (params[:date].to_date rescue false)
    days = Calendar.get_calendar(@today.year, @today.month)

    company = @current_user.company
    unless company.present? && company.groups.present?
      return render '/home/error'
    end

    @groups = company.groups
    @group = Group.last
    if params[:group].present?
      @group = Group.find(params[:group])
    else
      @group = @groups.first
    end

    days = add_schedule_to_calendar(@group, days)
    @weeks = days.each_slice(7).to_a
    @months = Calendar.get_months(5)
    months_rus = %w'Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'
    @month = months_rus[@today.month - 1]
  end

  def day_schedule
    return unless (params[:date].to_date rescue false) && params[:group]
    @group = Group.find(params[:group])
    @day_schedule = get_day_schedule(@group, params[:date])
    html = render_to_string 'schedules/day_schedule', :layout => false, :locals => {params: params}
    render text: html
  end

  private
  def add_schedule_to_calendar(group, days)
    group_schedule = group.schedule

    days.each do |day|
      if day[:active].present?
        group_schedule.each do |schedule|
          if day[:date].to_date == schedule[:date].to_date
            course_deadline = courses_from_ligament(schedule[:ligament_sections], schedule[:ligament_courses])
            day.merge!({ course_deadline: course_deadline })
          end
        end
      end
    end
    days
  end

  def get_day_schedule(group, date)
    group_schedule = group.schedule
    day_schedule = {}
    group_schedule.each do |schedule|
      if date.to_date == schedule[:date].to_date
        course_deadline = courses_from_ligament(schedule[:ligament_sections], schedule[:ligament_courses])
        course_deadline.each do |course|
          day_schedule.merge!({course => []})
        end

        schedule[:ligament_sections].each do |ligament_section|
          section = LigamentSection.find(ligament_section).section_id
          course = Section.find(section).course_id
          # day_schedule[course] << [section]
          day_schedule[course] << section
        end
      end
    end
    day_schedule
  end

  def courses_from_ligament(ligament_sections, ligament_courses)
    sections_ids = LigamentSection.where(id: ligament_sections).pluck(:section_id)
    courses_ids_from_section = Section.where(id: sections_ids).pluck(:course_id)
    courses_ids = LigamentCourse.where(id: ligament_courses).pluck(:course_id)
    course_deadline = courses_ids_from_section + courses_ids
    course_deadline.uniq
  end
end
