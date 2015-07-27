class SchedulesController < HomeController
  def index
    @current_user = current_user
    begin_of_month = DateTime.now.beginning_of_month.wday
    end_of_month = DateTime.now.end_of_month.wday
    before_month = begin_of_month - 1
    after_month = 7 - end_of_month

    days = []

    before_month.times do |day|
      date = DateTime.now.beginning_of_month - (before_month - day).day
      days << date.day
    end

    DateTime.now.end_of_month.day.times do |day|
      days << (day + 1)
    end

    after_month.times do |day|
      date = DateTime.now.end_of_month + (day + 1).day
      days << date.day
    end
    
    @days = days
  end
end
