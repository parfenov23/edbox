tabsCorusel = ->
  tabsWidth = $('.header__bottom .title .tabs').width()
  headerWidth = $('.header__bottom').width() - 69
  titleWidth = $('.header__bottom .title').width()
  if headerWidth < titleWidth + tabsWidth
    $('.header__bottom').addClass('carusel for_prev')

headerTabsLine = (elem) ->
  if $('.tabs__item').length
    width = $(elem).outerWidth()
    tabs_item_active = $(elem)
    if tabs_item_active.length > 0
      offset = tabs_item_active.position().left
      $('.header__bottom .tabs .line').animate(
        'width': width + 'px'
        'left': offset + 'px').dequeue 'fx'

adaptiveTitle = ->
  $('.adaptive-title').each ->
    rightWidth = $(@).find('.right-col').width()
    $(@).find('.left-col').css
      width: $(@).width() - rightWidth + 'px'


figcaptionTitleEclipses = (el, height) ->
  heights = []
  $(el).each (indx, element) ->
    if $(element).height() > height
      $(element).addClass 'over-title'

testList = ->
  parenBlock = $('.content#tests')
  if parenBlock.height() > $(window).height()
    parenBlock.addClass('fixed-btm')
    $('.finish-test').css
      width: parenBlock.width() + 'px'
      left: parenBlock.offset().left + 'px'


$(document).ready ->
  $('img:last').load ->

    figcaptionTitleEclipses('.corses-prev figcaption .title', 84)
    figcaptionTitleEclipses('.favorite-item .description .title', 56)
    figcaptionTitleEclipses('.corses-prev.compact figcaption .title', 73)


    $('.js__carusel').jcarousel()

    $('.select-deadline').on 'click', ->
      $(@).closest('.check_group_added').addClass('section__deadline')

    $('.section__deadline-title .back').on 'click', ->
      $(@).closest('.check_group_added').removeClass('section__deadline')

    $('.jcarousel-control-prev').on('jcarouselcontrol:active', ->
      $(this).removeClass 'inactive'
      return
    ).on('jcarouselcontrol:inactive', ->
      $(this).addClass 'inactive'
      return
    ).jcarouselControl target: '-=1'
    $('.jcarousel-control-next').on('jcarouselcontrol:active', ->
      $(this).removeClass 'inactive'
      return
    ).on('jcarouselcontrol:inactive', ->
      $(this).addClass 'inactive'
      return
    ).jcarouselControl target: '+=1'





    $('.js_for-tooltip').hover ->
      $(@).find('.js_tooltip').addClass('is-active')
    , ->
      $(@).find('.js_tooltip').removeClass('is-active')

    headerTabsLine('.tabs__item.active')
    $('.header__bottom .tabs .tabs__item').hover ->
      $(@).stop(true).queue 'fx', ->
        headerTabsLine(@)
    , ->
      $(@).stop(true).queue 'fx', ->
        headerTabsLine('.tabs__item.active')

    $('.carusel .next_arr i').on 'click', ->
      headerWidth = $('.header__bottom').width() - 69
      $('.header__bottom .title').animate
        marginLeft: - headerWidth + 'px', 300, ->
          $('.carusel.for_prev').removeClass('for_prev').addClass('for_next')

    $('.js__select-calendar').hover (->
      $(@).addClass('is__active')
      $('.js__backing').addClass('is__active')
      ), ->
      $(@).removeClass('is__active')

    $(document).on 'click', '.hidden-calendar-wrp .hidden-list li', ->
      parenBlock = undefined
      showId = undefined
      showId = $(this).data('show')
      parenBlock = $(this).closest('.hidden-calendar-wrp')
      parenBlock.find('.hidden-list').hide()
      parenBlock.find('.' + showId + ' ').show()

    $(document).on 'click', '.hidden-calendar-wrp .calendar-header .back', ->
      parenBlock = $(@).closest('.hidden-calendar-wrp')
      parenBlock.find('.hidden-calendar').hide()
      parenBlock.find('.hidden-list').show()

    $(document).on 'click', '.js__backing', ->
      $('.hidden-calendar-wrp .hidden-list, .hidden-calendar-wrp .hidden-calendar').hide()
      $(@).removeClass('is__active')

    $(document).on 'click', '.carusel .prev_arr i', ->
      $('.header__bottom .title').animate
        marginLeft: 0, 300, ->
          $('.carusel.for_next').removeClass('for_next').addClass('for_prev')




    $('.schedule-item .additional-info .action-btn').on 'click',(e) ->
      $(document).trigger 'click.dropdown'
      list = $(@).find('ul.hidden-list').show()
      $('body').bind 'click.dropdown', (ev) ->
        unless e.target.closest('.action-btn') == ev.target.closest('.action-btn')
          list.hide()
          $(document).unbind 'click.dropdown'

    $('.schedule-header .select-trigger').on 'click',(e) ->
      $(document).trigger 'click.dropdown'
      list = $(@).closest('.psevdo-select').find('ul.hidden-list').show()
      $('body').bind 'click.dropdown', (ev) ->
        unless e.target.closest('.psevdo-select') == ev.target.closest('.psevdo-select')
          list.hide()
          $(document).unbind 'click.dropdown'

    $('#js-add-course-to-shedule .select-trigger').on 'click', ->
      $(@).closest('.select').find('ul.hidden').show()

    adaptiveTitle()


    $('.js__toggle-state .fixed-h .title').on 'click', (e) ->
      $(document).trigger 'click.dropdown'
      el = $(@).closest('.js__toggle-state')
      hideBlock = (elem) ->
        $(elem).removeClass('open-state').addClass 'closed-state'
      if el.hasClass('closed-state')
        hideBlock('.js__toggle-state')
        el.removeClass('closed-state').addClass 'open-state'
        adaptiveTitle()
      else
        hideBlock(el)
      $('body').bind 'click.dropdown', (ev) ->
        unless e.target.closest('.js__toggle-state') == ev.target.closest('.js__toggle-state')
          hideBlock(el)
          $(document).unbind 'click.dropdown'


    tabsCorusel()
    testList()
