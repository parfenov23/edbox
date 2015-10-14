# TODO: удалить когда перейдем на совинную карусель (новый кабинет)
carusel = ->
  $('.js__carusel').jcarousel(
  )
  $('.jcarousel-control-prev').on('jcarouselcontrol:active', ->
    $(this).removeClass 'inactive'
  ).on('jcarouselcontrol:inactive', ->
    $(this).addClass 'inactive'
  ).jcarouselControl target: '-=2'

  $('.jcarousel-control-next').on('jcarouselcontrol:active', ->
    $(this).removeClass 'inactive'
  ).on('jcarouselcontrol:inactive', ->
    $(this).addClass 'inactive'
  ).jcarouselControl target: '+=2'

$(document).ready ->
  carusel()
