$.show_error = show_error = (text, duration) ->
  el = $('#alert')
  el.text(text).show 300
  setTimeout ->
    el.hide 400
  , duration or 3000

Backbone.View::route_error = $.route_error = (xhr) ->
  switch xhr.status
    when 401
      location.href = '/#signin'
      show_error 'Вы не авторизованы'
    when 404, 500
      show_error xhr.responseJSON.error
    else
      show_error 'Не удалось загрузить страницу'

Backbone.View::show_error = (text, duration) ->
  show_error text, duration or 3000
