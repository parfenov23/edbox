$(document).ready ->

  $('.schedule-item .additional-info .action-btn').on 'click',(e) ->
    $(document).trigger 'click.dropdown'
    list = $(@).find('ul.hidden-list').show()
    $('body').bind 'click.dropdown', (ev) ->
      unless e.target == ev.target
        list.hide()
        $(document).unbind 'click.dropdown'


  $('#js-add-course-to-shedule .select-trigger').on 'click', ->
    $(@).closest('.select').find('ul.hidden').show()

  $('.schedule-header .select-trigger').on 'click', ->
    $(@).closest('.psevdo-select').find('ul.hidden-list').show()

  $('.schedule-item.closed-state .fixed-h .title').on 'click', ->
    el = $(@).closest('.schedule-item')
    if el.hasClass('closed-state')
      $('.schedule-item').removeClass('open-state').addClass 'closed-state'
      el.toggleClass('closed-state').toggleClass 'open-state'
