tabsCorusel = ->
  tabsWidth = $('.header__bottom .title .tabs').width()
  headerWidth = $('.header__bottom').width() - 69
  titleWidth = $('.header__bottom .title').width()

  if headerWidth < titleWidth + tabsWidth
    $('.header__bottom').addClass('carusel for_prev')

$(document).ready ->
  $('img:last').load ->

    tabsCorusel()

    $('.carusel.for_prev .next_arr i').on 'click', ->
      headerWidth = $('.header__bottom').width() - 69
      $('.header__bottom .title').animate
        marginLeft: - headerWidth + 'px', 300, ->
          $('.carusel.for_prev').removeClass('for_prev').addClass('for_next')

    $('.carusel .prev_arr i').on 'click', ->
      console.log 12
      $('.header__bottom .title').animate
        marginLeft: 0, 300, ->
          $('.carusel.for_next').removeClass('for_next').addClass('for_prev')

    $('.adaptive-title').each ->
      rightWidth = $(@).find('.right-col').width()
      $(@).find('.left-col').css
        width: $(@).width() - rightWidth + 'px'

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

    $('.js__toggle-state .fixed-h .title').on 'click', (e) ->
      $(document).trigger 'click.dropdown'
      el = $(@).closest('.js__toggle-state')
      hideBlock = (elem) ->
        $(elem).removeClass('open-state').addClass 'closed-state'
      if el.hasClass('closed-state')
        hideBlock('.js__toggle-state')
        el.removeClass('closed-state').addClass 'open-state'
      else
        hideBlock(el)
      $('body').bind 'click.dropdown', (ev) ->
        unless e.target.closest('.js__toggle-state') == ev.target.closest('.js__toggle-state')
          hideBlock(el)
          $(document).unbind 'click.dropdown'
