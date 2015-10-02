calendarLocale =
  prevText: '&#x3c;Пред'
  nextText: 'След&#x3e;'
  currentText: 'Сегодня'
  monthNames: [
    'Январь'
    'Февраль'
    'Март'
    'Апрель'
    'Май'
    'Июнь'
    'Июль'
    'Август'
    'Сентябрь'
    'Октябрь'
    'Ноябрь'
    'Декабрь'
  ]
  monthNamesShort: [
    'Янв'
    'Фев'
    'Мар'
    'Апр'
    'Май'
    'Июн'
    'Июл'
    'Авг'
    'Сен'
    'Окт'
    'Ноя'
    'Дек'
  ]
  dayNames: [
    'воскресенье'
    'понедельник'
    'вторник'
    'среда'
    'четверг'
    'пятница'
    'суббота'
  ]
  dayNamesShort: [
    'вск'
    'пнд'
    'втр'
    'срд'
    'чтв'
    'птн'
    'сбт'
  ]
  dayNamesMin: [
    'Вс'
    'Пн'
    'Вт'
    'Ср'
    'Чт'
    'Пт'
    'Сб'
  ]
  dateFormat: 'dd.mm.yy'
  firstDay: 1
  isRTL: false
  minDate: new Date
  onSelect: (e) ->
    dates = $(this).data('datepicker')
    selectDate = dates.currentDay + '/' + dates.currentMonth + 1 + '/' + dates.currentYear
    $(this).parent().find('.selected-value').html selectDate
    if $(this).hasClass('js_changeDateToDatePicker')
      changeDateToDatePicker $(this)
    $(this).change()
    $(this).parent().addClass 'show'



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
      $("page__title")
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
  parentBlock = $('.content#tests')
  if parentBlock.height() > $(window).height()
    parentBlock.addClass('fixed-btm')
    $('.finish-test').css
      width: parentBlock.width() + 'px'
      left: parentBlock.offset().left + 'px'


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
      $('.auth__wrp .js__company-name input').focus()
      $('.auth__wrp .js__company-name .floating-label').text("Название компании")
    else
      $('.auth__wrp .js__company-name').removeClass('is__active')
      $('.auth__wrp .js__company-name').addClass('is__Noactive')
      $('.auth__wrp .js__company-name input').attr("placeholder", "")


adjustHeight = (textarea) ->
  textareaHeight = $(textarea).data('maxheight')

  if typeof textareaHeight == 'undefined'
    textareaHeight = 110

  if textarea.value
    if textarea.scrollHeight < textareaHeight
      dif = textarea.scrollHeight - (textarea.clientHeight)
      if dif
        if isNaN(parseInt(textarea.style.height))
          textarea.style.height = textarea.scrollHeight + 'px'
        else
          textarea.style.height = parseInt(textarea.style.height) + dif + 'px'
    else
      textarea.style.height = textareaHeight +  'px'
  else
    $(textarea).css 'height': '26px'


multiAction = (el) ->
  parentBlock = el.closest('.members__in_system director')

  if el.hasClass 'is__choosen'
    if $('.members__in_system .is__choosen').length == 1
      $('.js__multi__action').removeClass 'is__active'
    el.removeClass 'is__choosen'
  else
    $('.js__multi__action').addClass 'is__active'
    el.addClass 'is__choosen'

commonToggle = (el) ->
  $(el).on 'click', ->
    $(@).toggleClass 'is__active'



activeMenu = ->
  $('.js__action-menu .hidden-list li').on 'click', ->
    showBlock = $(@).data 'id'
    if showBlock == "innerCalendar"
      $(@).closest('.hidden__content').addClass 'is__show_calendar'
      $('.hidden-calendar-wrp .calendar-holder').datepicker(calendarLocale)
      $('.hidden-calendar .calendar-header .back__v2').on 'click', ->
        $(@).closest('.hidden__content').removeClass 'is__show_calendar'

    else if showBlock == "showSectionList"
      $('.js__section_popup').fadeIn().addClass 'is__active'
    else if showBlock == "delete"
      console.log showBlock


# функция которая скрывает блок по клику вне его
hideElementOutOff = (elem, parentBlock, e) ->
  $(document).trigger 'click.dropdown'
  $(elem).fadeIn()
  $('body').bind 'click.dropdown', (ev) ->
    unless $(e.target).closest(parentBlock).length == $(ev.target).closest(parentBlock).length
      elem.fadeOut()
      parentBlock.removeClass 'is__active'
      $(document).unbind 'click.dropdown'


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
  commonToggle('.courses-aside.add__users .item')
  activeMenu()

  $(document).on 'click', '.programm__block > .adaptive__title i', ->
    parentBlock = $(@).closest '.programm__block'
    if !parentBlock.hasClass('is__shot')
      parentBlock.addClass 'is__shot'
    else
      parentBlock.removeClass 'is__shot'

  $(document).on 'click', '.plane__list .item.js_openHiddenPart', ->
    parent_block = $(@).closest(".js_parentRequestSend")
    $('.plane__list .item')
      .removeClass 'is__active'
      .addClass 'is__NOactive'
      .find '.visibile__part .action__block .btn'
      .addClass 'btn-flat'
      .removeClass 'is__blue'
    $(@)
      .addClass 'is__active'
      .removeClass 'is__NOactive'
      .find '.visibile__part .action__block .btn'
      .removeClass 'btn-flat'
    parent_block.find(".form__SendMessage .hidden__part")
      .show()
      .removeClass("left")
      .removeClass("right")
      .addClass($(@).data('type'));
    parent_block.find("input[name='type_account']").val($(@).data('type_account'))
    if $(@).data('show') != undefined || $(@).data('show') != ""
      parent_block.find($(@).data('show')).closest('.item').show()
    if $(@).data('hide') != undefined || $(@).data('hide') != ""
      parent_block.find($(@).data('hide')).val('').closest('.item').hide().addClass("empty")

  $(document).on 'click', '.add__leadings .visible__part', (e) ->
    parentBlock = $(@).closest '.item'
    elem = parentBlock.find '.hidden__part'
    parentBlock.addClass 'is__active'
    hideElementOutOff(elem, parentBlock , e)

  $('#js-add-course-to-shedule .select-trigger').on 'click', (e) ->
    parentBlock = $(@).closest '.select'
    elem = parentBlock.find '.listGroup'
    hideElementOutOff(elem, parentBlock , e)



  $(document).on 'keyup', '.com__input-item textarea, .com__input-item input', ->
    list = $(@).closest '.com__input-item'
      .find '.hidden-list'
    if $(@).val() == ''
      list.fadeOut 300
    else
      list.fadeIn 300


  $('.btn-group > .btn').on 'click', (e) ->
    parentBlock = $(@).closest('.btn-group')
    elem  = parentBlock.find('ul.hidden-list')
    hideElementOutOff(elem, parentBlock , e)

  $('.tegs__add_block .show__more').on 'click', ->
    $(@).fadeOut()
      .closest '.tegs__add_block'
      .find '.visible__viewport'
      .addClass 'is__unfold'

  $('.btn-group > .btn').on 'click', ->
    $(@).closest('.btn-group').find('.hidden-list').fadeIn()


  $('.header__with_search input').on 'focusin', ->
    $('.search__content').addClass('is__visible')
  $('.header__with_search input').on 'focusout', ->
    if !$('.search__content').is ':has(div)'
      $('.search__content').removeClass('is__visible')

  $('.js__toggle_review-list').on 'click', ->
    $(@).closest('.review__section').toggleClass('is__opened')


  $('.item.course__block_horizontal-shot input, .course__block_horizontal input').datepicker(calendarLocale)


  $('.members__in_system-item').on 'click', ->
    if !$(this).hasClass("noHeaderOpen")
      multiAction($(this))

  $('.js__action-menu .icon__block').on 'click', ->
    $(@).closest('.js__action-menu').toggleClass 'is__active'
    $('.js__backing').toggleClass 'is__active'

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


  $('.com__input-item textarea').on 'keyup onpaste', (e) ->
    adjustHeight(e.target)

  $('.com__input-item input, .com__input-item textarea').on 'focusout', ->
    $(@).closest('.com__input-item').addClass 'is__noFocus'
  $('.com__input-item input, .com__input-item textarea').on 'focusin', ->
    $(@).closest('.com__input-item').removeClass 'is__noFocus'



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

  $('.js__show-aside-main-nav').on 'click', ->
    $('.js__left-aside, .js__backing').addClass('is__active')

  $('.select-deadline').on 'click', ->
    form = $(@).closest('form')
    if form.find('.parentDatePickerTime').val().length > 0
      $(@).closest("form").find(".action-btn").hide()
      $(@).closest("form").find(".action-btn.actionSectionDeadLine").show()
      $(@).closest('.check_group_added').addClass('section__deadline')
    else
      show_error('Установите срок прохождения курса', 3000)


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
    parentBlock = undefined
    showId = undefined
    showId = $(this).data('show')
    parentBlock = $(this).closest('.hidden-calendar-wrp')
    parentBlock.find('.hidden-list').hide()
    parentBlock.find('.' + showId + ' ').show()
    installPositionBlock(parentBlock.find('.hidden-calendar'))

  $(document).on 'click', '.hidden-calendar-wrp .calendar-header .back', ->
    parentBlock = $(@).closest('.hidden-calendar-wrp')
    parentBlock.find('.hidden-calendar').hide()
    parentBlock.find('.hidden-list').show()

  $(document).on 'click', '.js__backing', ->
    $('.hidden-calendar-wrp .hidden-list, .hidden-calendar').hide()
    $('.hidden__content').removeClass 'is__show_calendar'
    $('.js__action-menu').removeClass 'is__active'
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
    unless ($(ev.target).closest('.js__toggle-state').length || $(ev.target).closest(".noCloseToggleState").length || $(ev.target).is('[class^="ui-datepicker"]'))
      hideBlock($('.js__toggle-state'))
      adaptiveTitle()
      $(document).unbind 'click.dropdown'
