require 'calendar'
class SchedulesController < HomeController
  def index
    @current_user = current_user
    days = Calendar.get_calendar(DateTime.now.year, DateTime.now.month)
    days = add_schedule(@current_user, days)
    @weeks = days.each_slice(7).to_a
  end

  private
  def add_schedule(user, days)
    user_schedule = user.schedule
    days.each do |day|
      if day[:active].present?
        user_schedule.each do |schedule|
          if day[:date].to_date == schedule[:date].to_date
            sections_ids = BunchSection.where(id: schedule[:bunch_sections]).pluck(:section_id)
            courses_ids_from_section = Section.where(id: sections_ids).pluck(:course_id)
            courses_ids = BunchCourse.where(id: schedule[:bunch_courses]).pluck(:course_id)
            course_deadline = courses_ids_from_section + courses_ids
            day.merge!({ course_deadline: course_deadline.uniq })
          end
        end
      end
    end
    days
  end
end
