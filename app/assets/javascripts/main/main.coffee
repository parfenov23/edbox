headerTabsLine = (elem) ->
  if $('.page__children .item').length
    width = $(elem).outerWidth()
    tabs_item_active = $(elem)
    if tabs_item_active.length > 0
      offset = tabs_item_active.position().left
      $('.page__children .line').animate(
        'width': width + 'px'
        'left': offset + 'px').dequeue 'fx'

hideBlock = (elem) ->
  $(elem).removeClass('open-state').addClass 'closed-state'

headerSubmenu = ->
  headerWidth = $('#page__header').width()
  chPageWidth = $('.page__children').width()
  titleWidth = $('.page__title ').width()
  rightWidt = $('.right-col').width()
  if chPageWidth + titleWidth + 107 > headerWidth - rightWidt
    if( $("#namePageGroup").length)
      $(".page__title").text($("#namePageGroup").val())
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

showHideToggleBtn = ->
  $('.js__showHideToggleBtn').each ->
    descriptionHeight = $(@).find('.description').height()
    if descriptionHeight > 80
      $(@).addClass('is__shot')


toggleNotesAsideHeight = ->
  $('.toggle-viewport').on 'click', ->
    if $(@).hasClass 'for__less'
      $(@).removeClass('for__less').closest('.item').addClass('is__shot')
    else
      $(@).addClass('for__less').closest('.item').removeClass('is__shot')


authCorpAcc =->
  $('.type__acc-item input').on 'click', ->
    if $('.type__acc-item .corp__acc input').is(':checked')
      $('.auth__wrp .js__company-name').addClass('is__active')
      $('.auth__wrp .js__company-name').removeClass('is__NOactive')
      $('.auth__wrp .js__company-name input').attr("placeholder", "Название компании").focus()
    else
      $('.auth__wrp .js__company-name').removeClass('is__active')
      $('.auth__wrp .js__company-name').addClass('is__Noactive')
      $('.auth__wrp .js__company-name input').attr("placeholder", "")


$(document).ready ->

  figcaptionTitleEclipses('.corses-prev figcaption .title', 84)
  figcaptionTitleEclipses('.favorite-item .description .title', 56)
  figcaptionTitleEclipses('.corses-prev.compact figcaption .title', 73)
  headerTabsLine('.page__children .item.active')
  testList()
  headerSubmenu()
  carusel()
  adaptiveTitle()
  showHideToggleBtn()
  toggleNotesAsideHeight()
  authCorpAcc()






  $('.courses-aside .js__baron').on 'scroll', ->
    scrollHeight = $(@).scrollTop()
    parentBlock = $(@).closest('.courses-aside')
    if scrollHeight > 10
      parentBlock.addClass('is__scrolled')
    else
      parentBlock.removeClass('is__scrolled')

  $('.note-holder .action__block .edit').on 'click', ->
    $(@).closest('.courses-aside').addClass('is__edit')

  $('.help__wrp .item .wrp').on 'click', ->
    $(@).closest('.item').find('.hidden__block').addClass('is__active')
  $('.help__wrp .item .hidden__block >.title').on 'click', ->
    $(@).parent().removeClass('is__active')

  $('.js__tooltip').hover (->
    $(@).addClass('is__visible-tooltip')
  ), ->
    $(@).removeClass('is__visible-tooltip')

  if $('#js__toTogglescreen').length
    fsButton = document.getElementById('js__toTogglescreen')
    fsElement = document.getElementById('js__text-content')
    if window.fullScreenApi.supportsFullScreen
      console.log 'YES: Your browser supports FullScreen'
      console.log 'fullScreenSupported'
      fsButton.addEventListener 'click', (->
        window.fullScreenApi.requestFullScreen fsElement
        return
      ), true
      fsElement.addEventListener fullScreenApi.fullScreenEventName, (->
        if fullScreenApi.isFullScreen()
          console.log 'Whoa, you went fullscreen'
          $('.text__content').addClass("is__fullscrn")
        else
          console.log 'Back to normal'
          $('.text__content').removeClass("is__fullscrn")

        return
      ), true
    else
      console.log 'SORRY: Your browser does not support FullScreen'

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
    form = $(@).closest('form')
    if form.find('.parentDatePickerTime').val().length > 0
      $(@).closest("form").find(".action-btn").hide()
      $(@).closest("form").find(".action-btn.actionSectionDeadLine").show()
      $(@).closest('.check_group_added').addClass('section__deadline')
    else
      show_error('Установите крайний срок прохождения курса', 3000);

#  $('.section__deadline-title .back, .section__deadline .actionSectionDeadLine .yes').on 'click', ->
#    $(@).closest("form").find(".action-btn").show()
#    $(@).closest("form").find(".action-btn.actionSectionDeadLine").hide()
#    $(@).closest('.check_group_added').removeClass('section__deadline')

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
        $(@).removeClass('is__active')

  $(document).on 'click', '.hidden-calendar-wrp .hidden-list li', ->
    parenBlock = undefined
    showId = undefined
    showId = $(this).data('show')
    parenBlock = $(this).closest('.hidden-calendar-wrp')
    parenBlock.find('.hidden-list').hide()
    parenBlock.find('.' + showId + ' ').show()
    installPositionBlock(parenBlock.find('.hidden-calendar'))

  $(document).on 'click', '.hidden-calendar-wrp .calendar-header .back', ->
    parenBlock = $(@).closest('.hidden-calendar-wrp')
    parenBlock.find('.hidden-calendar').hide()
    parenBlock.find('.hidden-list').show()

  $(document).on 'click', '.js__backing', ->
    $('.hidden-calendar-wrp .hidden-list, .hidden-calendar-wrp .hidden-calendar').hide()
    $(@).removeClass('is__active')
    $('.js__left-aside').removeClass('is__active')
    $('.courses-aside').removeClass('show')

  $('.schedule-item .additional-info .action-btn').on 'click', (e) ->
    $(document).trigger 'click.dropdown'
    list = $(@).find('ul.hidden-list').show()
    $('body').bind 'click.dropdown', (ev) ->
      unless e.target.closest('.action-btn') == ev.target.closest('.action-btn')
        list.hide()
        $(document).unbind 'click.dropdown'

  $('.schedule-header .select-trigger').on 'click', (e) ->
    $(document).trigger 'click.dropdown'
    list = $(@).closest('.psevdo-select').find('ul.hidden-list').show()
    $('body').bind 'click.dropdown', (ev) ->
      unless e.target.closest('.psevdo-select') == ev.target.closest('.psevdo-select')
        list.hide()
        $(document).unbind 'click.dropdown'

  $('#js-add-course-to-shedule .select-trigger').on 'click', ->
    $(@).closest('.select').find('ul.hidden').show()

  $(document).on 'click', '.js__toggle-state .fixed-h .title', (e) ->
    $(document).trigger 'click.dropdown'
    el = $(@).closest('.js__toggle-state')
    if el.hasClass('closed-state')
      hideBlock('.js__toggle-state')
      el.removeClass('closed-state').addClass 'open-state'
      adaptiveTitle()
    else
      hideBlock(el)
      adaptiveTitle()

  $('body').bind 'click.dropdown', (ev) ->
    unless $(ev.target.closest('.js__toggle-state')).length
      hideBlock($('.js__toggle-state'))
      adaptiveTitle()
      $(document).unbind 'click.dropdown'
