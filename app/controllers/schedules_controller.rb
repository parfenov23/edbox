require 'calendar'
class SchedulesController < HomeController
  def index
    @current_user = current_user
    today = DateTime.now
    today = params[:date].to_date if (params[:date].to_date rescue false)
    days = Calendar.get_calendar(today.year, today.month)
    days = add_schedule_to_calendar(@current_user, days)
    @weeks = days.each_slice(7).to_a
    @months = Calendar.get_months(5)
    months_rus = %w'Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'
    @month = months_rus[today.month - 1]
  end

  def day_schedule
    return unless (params[:date].to_date rescue false)
    @day_schedule = get_day_schedule(current_user, params[:date])
    html = render_to_string 'schedules/day_schedule', :layout => false, :locals => {params: params}
    render text: html
  end

  private
  def add_schedule_to_calendar(user, days)
    user_schedule = user.schedule
    days.each do |day|
      if day[:active].present?
        user_schedule.each do |schedule|
          if day[:date].to_date == schedule[:date].to_date
            course_deadline = courses_from_bunch(schedule[:bunch_sections], schedule[:bunch_courses])
            day.merge!({ course_deadline: course_deadline })
          end
        end
      end
    end
    days
  end

  def get_day_schedule(user, date)
    user_schedule = user.schedule
    day_schedule = {}
    user_schedule.each do |schedule|
      if date.to_date == schedule[:date].to_date
        course_deadline = courses_from_bunch(schedule[:bunch_sections], schedule[:bunch_courses])
        course_deadline.each do |course|
          day_schedule.merge!({course => []})
        end

        schedule[:bunch_sections].each do |bunch_section|
          section = BunchSection.find(bunch_section).section_id
          course = Section.find(section).course_id
          day_schedule[course] << [section]
        end
      end
    end
    day_schedule
  end

  def courses_from_bunch(bunch_sections, bunch_courses)
    sections_ids = BunchSection.where(id: bunch_sections).pluck(:section_id)
    courses_ids_from_section = Section.where(id: sections_ids).pluck(:course_id)
    courses_ids = BunchCourse.where(id: bunch_courses).pluck(:course_id)
    course_deadline = courses_ids_from_section + courses_ids
    course_deadline.uniq
  end
end
