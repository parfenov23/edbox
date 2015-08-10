headerTabsLine = (elem) ->
  if $('.page__children .item').length
    width = $(elem).outerWidth()
    tabs_item_active = $(elem)
    if tabs_item_active.length > 0
      offset = tabs_item_active.position().left
      $('.page__children .line').animate(
        'width': width + 'px'
        'left': offset + 'px').dequeue 'fx'

headerSubmenu = ->
  headerWidth = $('#page__header').width()
  chPageWidth = $('.page__children').width()
  titleWidth = $('.page__title ').width()
  rightWidt = $('.right-col').width()
  if chPageWidth + titleWidth + 107 > headerWidth- rightWidt
    $('#page__header .left-col').addClass('is__sooo-long')
    $('#page__header').removeClass('with__children ')
    $('#page__header .page__children').addClass('js__baron')

adaptiveTitle = ->
  $('.adaptive__title').each ->
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

  # $('.jcarousel').on 'jcarousel:firstin', 'li', (event, carousel) ->
  #   qty = carousel._items.length
  #   last = carousel._last
  #   if $(last).index()+3 == qty
  #     $('.jcarousel-control-next').addClass 'inactive'
  #   else
  #     $('.jcarousel-control-next').removeClass 'inactive'
  #
  #   console.log last


$(document).ready ->
  $('img:last').load ->

    figcaptionTitleEclipses('.corses-prev figcaption .title', 84)
    figcaptionTitleEclipses('.favorite-item .description .title', 56)
    figcaptionTitleEclipses('.corses-prev.compact figcaption .title', 73)

    $('.js__tooltip').hover (->
      $(@).addClass('is__visible-tooltip')
      ), ->
      $(@).removeClass('is__visible-tooltip')

    headerSubmenu()

    carusel()

    $('.course__info .more').on 'click', ->
      $('.detail__info').toggleClass('is__closed')
      $(@).toggleClass('is__closed')

    $('.toggle__view.btn').on 'click', ->
      $('.study__program').toggleClass('is__closed')
      $(@).toggleClass('is__closed')

    $('.is__sooo-long .page__title').on 'click', ->
      $(@).next().toggle 300

    $(window).scroll ->
      scrollHeight = $('body').scrollTop()
      if scrollHeight > 1
        $('#page__header').addClass('is__white')
      else
        $('#page__header').removeClass('is__white')

    $('.js__show-aside-main-nav').on 'click', ->
      $('.js__left-aside, .js__backing').addClass('is__active')

    $('.select-deadline').on 'click', ->
      $(@).closest("form").find(".action-btn").hide()
      $(@).closest('.check_group_added').addClass('section__deadline')

    $('.section__deadline-title .back').on 'click', ->
      $(@).closest("form").find(".action-btn").show()
      $(@).closest('.check_group_added').removeClass('section__deadline')

    $('.js_for-tooltip').hover ->
      $(@).find('.js_tooltip').addClass('is-active')
    , ->
      $(@).find('.js_tooltip').removeClass('is-active')

    $('.page__children .item').hover ->
      $(@).stop(true).queue 'fx', ->
        headerTabsLine(@)
    , ->
      $(@).stop(true).queue 'fx', ->
        headerTabsLine('.page__children .item.active')

    $('.js__select-calendar').hover (->
      $(@).addClass('is__active')
      $('.js__backing').addClass('is__active')
      ), ->
      if $('#ui-datepicker-div').is(':hidden')
        console.log 12
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
      $('.js__left-aside').removeClass('is__active')

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

    headerTabsLine('.page__children .item.active')
    # tabsCorusel()
    testList()
