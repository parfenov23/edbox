$(document).ready ->
  $(document).on 'click', '#js-add-course-to-shedule .select-trigger', (e) ->
    parentBlock = $(@).closest '.select'
    elem = parentBlock.find '.listGroup'
    #hideElementOutOff(elem, parentBlock , e)
