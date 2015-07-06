$(document).ready ->

  $('.schedule-item .additional-info .action-btn').on 'click', ->
    $(@).find('.hidden-list').toggle()
    
  $('#js-add-course-to-shedule .select-trigger').on 'click', ->
    $(@).closest('.select').find('ul.hidden').show()
