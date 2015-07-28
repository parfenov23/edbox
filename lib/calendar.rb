class Calendar
  def self.get_calendar(year, month)
    current = DateTime.new(year, month)
    begin_of_month = current.beginning_of_month
    end_of_month = current.end_of_month
    before_month = begin_of_month.wday - 1
    after_month = 7 - end_of_month.wday

    month = %w'Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'
    week_days = %w'ПН ВТ СР ЧТ ПТ СБ ВС'

    days = []

    before_month.times do |day|
      date = begin_of_month - (before_month - day).day
      days << {
        date: date,
        day: date.day,
        month: month[date.month - 1],
        week_day: week_days[date.wday - 1]
      }
    end

    end_of_month.day.times do |day|
      date = begin_of_month + day.day
      days << {
        date: date,
        day: date.day,
        month: month[date.month - 1],
        week_day: week_days[date.wday - 1],
        active: true
      }
      if date.day == DateTime.now.day
        days.last.merge!({ today: true })
      end
    end

    after_month.times do |day|
      date = end_of_month + (day + 1).day
      days << {
        date: date,
        day: date.day,
        month: month[date.month - 1],
        week_day: week_days[date.wday - 1]
      }
    end
    days
  end
end
