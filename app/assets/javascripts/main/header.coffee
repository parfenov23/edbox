headerTabsLine = (elem) ->
  if $('.page__children .item').length
    width = $(elem).outerWidth()
    tabs_item_active = $(elem)
    if tabs_item_active.length > 0
      offset = tabs_item_active.position().left
      $('.page__children .line').animate(
        'width': width + 'px'
        'left': offset + 'px').dequeue 'fx'

$(document).ready ->
  headerTabsLine('.page__children .item.active')
  $('.page__children .item').hover ->
    $(@).stop(true).queue 'fx', ->
      headerTabsLine(@)
  , ->
    $(@).stop(true).queue 'fx', ->
      headerTabsLine('.page__children .item.active')
