Backbone.View::rippleTarget = (e, cls) ->
  targetClass = $(e.target).closest cls
  ink = undefined
  d = undefined
  x = undefined
  y = undefined
  if targetClass.find('.ink').length == 0
    targetClass.prepend '<span class=\'ink\'></span>'
  ink = targetClass.find('.ink')
  ink.removeClass 'animate'
  if !ink.height() and !ink.width()
    d = Math.max(targetClass.outerWidth(), targetClass.outerHeight())
    ink.css
      height: d
      width: d
  x = e.pageX - targetClass.offset().left - ink.width() / 2
  y = e.pageY - targetClass.offset().top - ink.height() / 2
  ink.css(
    top: y + 'px'
    left: x + 'px').addClass 'animate'
