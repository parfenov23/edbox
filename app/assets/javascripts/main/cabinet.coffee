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
# это нормальная карусель
  $('#owl-example').owlCarousel
    items : 3
    itemsDesktop: [999, 3]
    itemsDesktopSmall: [768, 3]
    itemsTablet: false
    itemsMobile: false
    navigation: true
    mouseDrag: false
    rewindNav: false
    responsiveRefreshRate: 10
    scrollPerPage: true
    slideSpeed: 800

  $('.js__next__item-carusel').on 'click', ->
    $('#owl-example').trigger('owl.next')

  $('.js__prev__item-carusel').on 'click', ->
    $('#owl-example').trigger('owl.prev')
