class Calendar
  def self.get_calendar(year, month)
    current = DateTime.new(year, month)
    begin_of_month = current.beginning_of_month
    end_of_month = current.end_of_month
    before_month = ((begin_of_month.wday + 6) % 7)
    after_month = 6 - ((end_of_month.wday + 6) % 7)

    week_days = %w'ПН ВТ СР ЧТ ПТ СБ ВС'

    days = []
    before_month.times do |day|
      date = begin_of_month - (before_month - day).day
      days << {
        date: date,
        day: date.day,
        week_day: week_days[date.wday - 1]
      }
    end

    end_of_month.day.times do |day|
      date = begin_of_month + day.day
      days << {
        date: date,
        day: date.day,
        week_day: week_days[date.wday - 1],
        active: true
      }
      if date.today?
        days.last.merge!({ today: true })
      end
    end

    after_month.times do |day|
      date = end_of_month + (day + 1).day
      days << {
        date: date,
        day: date.day,
        week_day: week_days[date.wday - 1]
      }
    end
    days
  end

  def self.get_months(count=1)
    months_rus = %w'Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноябрь Декабрь'
    now = DateTime.now
    months = [
      {
        date: DateTime.new(now.year, now.month).to_date,
        month: months_rus[now.month - 1],
      }
    ]
    (count-1).times do |i|
      day = months.last[:date].next_month
      months << {
        date: day.to_date,
        month: months_rus[day.month - 1],
      }
    end
    months
  end
end
