# Как $().toggle(boolean), только с анимацией
$.fn.sldToggle = (boolean = !@is ':visible')->
  do @[if boolean then 'slideDown' else 'slideUp']
  @
