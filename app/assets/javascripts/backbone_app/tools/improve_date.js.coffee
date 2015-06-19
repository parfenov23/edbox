months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек']
week_days = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье']

$.improve_date = (today, date) ->
  d = new Date date
  month = months[d.getMonth()] + '.'
  day = d.getDate()
  week_day = week_days[d.getDay() - 1]
  hour = d.getHours()
  hour = '0' + hour if hour < 10
  minutes = d.getMinutes()
  minutes = '0' + minutes if minutes < 10

  today_month = months[today.getMonth()] + '.'
  today_day = today.getDate()

  time = hour + ':' + minutes
  time = 'Весь день' if time == '23:59'

  time: time
  date: if today_month == month and today_day == day then 'Сегодня' else week_day + ' ' + day

$.common_duration = $.last_status_duration = (today, date) ->
  parseInt((today.getTime() - (new Date date).getTime()) / 86400000)

$.date_plus_two_weeks = (date) ->
  d = new Date date.getTime() + 14 * 24 * 60 * 60 * 1000
  short_date d

$.next_monday = (date) ->
  d = new Date date.getTime() + (8 - date.getDay()) * 24 * 60 * 60 * 1000
  short_date d

$.short_date = short_date = (d) ->
  month = months[d.getMonth()] + '.'
  day = d.getDate()
  day + ' ' + month

$.makeDateTime = (date, time) ->
  date_arr = date.split '.'
  time_arr = time.split ':'
  date_time = new Date(date_arr[2], date_arr[1] - 1, date_arr[0], time_arr[0], time_arr[1])

$.half_hours = ->
  arr = ['Весь день']
  _.each [0..23], (el) ->
    arr.push el + ':00'
    arr.push el + ':30'
  arr

$.calendar_date = (d) ->
  date = new Date d
  return false if date + '' == 'Invalid Date'
  date.getDate() + '.' + (date.getMonth() + 1) + '.' + (date.getYear() + 1900)
