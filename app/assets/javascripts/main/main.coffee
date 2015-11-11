# это только на заметках
# showHideToggleBtn = ->
#   $('.js__showHideToggleBtn').each ->
#     descriptionHeight = $(@).find('.description').height()
#     if descriptionHeight > 80
#       $(@).addClass('is__shot')
#
# toggleNotesAsideHeight = ->
#   $('.toggle-viewport').on 'click', ->
#     if $(@).hasClass 'for__less'
#       $(@).removeClass('for__less').closest('.item').addClass('is__shot')
#     else
#       $(@).addClass('for__less').closest('.item').removeClass('is__shot')
#
# $(document).on 'click', '.js__toggle-state .fixed-h .title', (e) ->
#   $(document).trigger 'click.dropdown'
#   el = $(@).closest('.js__toggle-state')
#   if el.hasClass('closed-state')
#     hideBlock('.js__toggle-state')
#     el.removeClass('closed-state').addClass 'open-state'
#     adaptiveTitle()
#   else
#     hideBlock(el)
#     adaptiveTitle()
#
#  $('.js__select-calendar').hover (->
#    $(@).addClass('is__active')
#    $('.js__backing').addClass('is__active')
#  ), ->
#    if $('#ui-datepicker-div').is(':hidden') || !$('#ui-datepicker-div').length
#      $(@).removeClass('is__active')
#
# $('.select-deadline').on 'click', ->
#   form = $(@).closest('form')
#   if form.find('.parentDatePickerTime').val().length > 0
#     $(@).closest("form").find(".action-btn").hide()
#     $(@).closest("form").find(".action-btn.actionSectionDeadLine").show()
#     $(@).closest('.check_group_added').addClass('section__deadline')
#   else
#     show_error('Установите срок прохождения курса', 3000)
#
# $('.is__sooo-long .page__title').on 'click', ->
#   $(@).next().toggle 300
#
  # $('.note-holder .action__block .edit').on 'click', ->
  #   $(@).closest('.courses-aside').addClass('is__edit')
  #





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
    selectDate = dates.currentDay + '.' + dates.currentMonth + '.' + dates.currentYear
    $(this).parent().find('.selected-value').html selectDate
    if $(this).hasClass('js_changeDateToDatePicker')
      changeDateToDatePicker $(this)
#    $(this).change()
    $(this).parent().addClass 'show'


# TODO: переработать название
hideBlock = (elem) ->
  $(elem).removeClass('open-state').addClass 'closed-state'
commonToggle = (el) ->
  $(el).on 'click', ->
    $(@).toggleClass 'is__active'


adaptiveTitle = ->
  $('.adaptive__title').each ->
    rightWidth = $(@).find('.right-col').width()
    $(@).find('.left-col').css
      width: $(@).width() - rightWidth + 'px'


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

activeMenu = ->
  $('.js__action-menu .hidden-list li').on 'click', ->
    showBlock = $(@).data 'id'
    if showBlock == "innerCalendar"
      $(@).closest('.hidden__content').addClass 'is__show_calendar'
#      $('.hidden-calendar-wrp .calendar-holder').datepicker(calendarLocale)
      $('.hidden-calendar .calendar-header .back__v2').on 'click', ->
        $(@).closest('.hidden__content').removeClass 'is__show_calendar'

    else if showBlock == "showSectionList"
      $('.js__section_popup').fadeIn().addClass 'is__active'
    else if showBlock == "delete"
      console.log showBlock
    else if showBlock == "selectCourseGroup"
      $(this).closest(".single-course").addClass("selected")
      $(".js__action-menu.is__active").removeClass("is__active")
      $(".js__action-menu .is__show_calendar").removeClass("is__show_calendar")


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
  # showHideToggleBtn()
  # toggleNotesAsideHeight()
  # testList()
  adaptiveTitle()
  commonToggle('.courses-aside.add__users .item')
  activeMenu()

# дико странный блок показанный незарегестрированным пользователям
# там выбор планов
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
      .addClass($(@).data('type'))
    parent_block.find("input[name='type_account']")
      .val $(@).data('type_account')
    if $(@).data('show') != undefined || $(@).data('show') != ""
      parent_block.find($(@).data('show')).closest('.item').show()
    if $(@).data('hide') != undefined || $(@).data('hide') != ""
      parent_block
        .find $(@).data('hide')
        .val('')
        .closest '.item'
        .hide()
        .addClass 'empty'

# расскрытие выпадающего списка в кнопке-группе
  $(document).on 'click', '.btn-group > .btn', (e) ->
    parentBlock = $(@).closest('.btn-group')
    elem  = parentBlock.find('ul.hidden-list')
    hideElementOutOff(elem, parentBlock , e)


  $('.item.course__block_horizontal-shot input, .course__block_horizontal input').datepicker(calendarLocale)


  $(document).on 'click', '.members__in_system-item', ->
    if !$(@).hasClass("noHeaderOpen")
      multiAction($(@))

# счетчик сотрудников на странице выбора тарифа
  $(document).on 'click', '.js__stuf_count .js__change_qty_stuf', ->
    input = $('.js__stuf_count input')
    futVal = parseInt(input.val()) + parseInt($(@).data 'delta')
    input.val(futVal)
    input.change()
    min_val = 1
    if (input.data('default') != undefined )
      min_val = parseInt(input.data('default'))
    if futVal > min_val
      $('.js__stuf_count').removeClass 'is__empty'
    else if futVal == min_val
      $('.js__stuf_count').addClass 'is__empty'


# дропдаун который заподлицо
  $(document).on 'click', '.js__dropdown_toggle .visible__part', (e) ->
    parentBlock = $(@).closest '.js__dropdown_toggle'
    elem = parentBlock.find('.hidden__list')
    hideElementOutOff(elem, parentBlock, e)

# новый выпадающий список в трех точках (его появление)
  $(document).on 'click', '.js__action-menu .icon__block', ->
    $(".js__action-menu.is__active").removeClass("is__active")
    $(".js__action-menu .is__show_calendar").removeClass("is__show_calendar")
    $(@).closest('.js__action-menu').toggleClass 'is__active'
    $('.js__backing').toggleClass 'is__active'


# скрытиe раскрытие добавочной информации
  $(document).on 'click', '.course__info .more, .toggle__view.btn', ->
    $('.detail__info, .study__program').toggleClass('is__closed')
    $(@).toggleClass('is__closed')


# увеличение высоты текстарее
  $('.com__input-item textarea').on 'keyup onpaste', (e) ->
    adjustHeight(e.target)


# при потере фокуса перекрашивает лейблы
  $('.com__input-item input, .com__input-item textarea').on 'focusout', ->
    $(@).closest('.com__input-item').addClass 'is__noFocus'
  $('.com__input-item input, .com__input-item textarea').on 'focusin', ->
    $(@).closest('.com__input-item').removeClass 'is__noFocus'


# странное поведение в асайде при скроле
  $('.courses-aside .js__baron').on 'scroll', ->
    scrollHeight = $(@).scrollTop()
    parentBlock = $(@).closest('.courses-aside')
    if scrollHeight > 10
      parentBlock.addClass('is__scrolled')
    else
      parentBlock.removeClass('is__scrolled')


# показ тултипа
# TODO: вынести в функцию
  $('.js_for-tooltip').hover ->
    $(@).find('.js_tooltip').addClass('is-active')
  , ->
    $(@).find('.js_tooltip').removeClass('is-active')

  $('.js__tooltip').hover (->
    $(@).addClass('is__visible-tooltip')
  ), ->
    $(@).removeClass('is__visible-tooltip')


# какая то белиберда со скрытым списком и календарем
  $(document).on 'click', '.hidden-calendar-wrp .hidden-list li', ->
    parentBlock = undefined
    showId = undefined
    showId = $(this).data('show')
    parentBlock = $(this).closest('.hidden-calendar-wrp')
    parentBlock.find('.hidden-list').hide()
    parentBlock.find('.' + showId + ' ').show()
    includeDatePicker($('.datapicker__trigger, .js__set-date'))
    installPositionBlock(parentBlock.find('.hidden-calendar'))


# скрытие календаря при клике на стрелку
  $(document).on 'click', '.hidden-calendar-wrp .calendar-header .back', ->
    parentBlock = $(@).closest('.hidden-calendar-wrp')
    parentBlock.find('.hidden-calendar').hide()
    parentBlock.find('.hidden-list').show()


# скрывает все по клику на .js__backing
  $(document).on 'click', '.js__backing, .md-overlay', ->
    $('.hidden-calendar-wrp .hidden-list, .hidden-calendar').hide()
    $('.hidden__content').removeClass 'is__show_calendar'
    $('.js__action-menu, .js__left-aside').removeClass 'is__active'
    $('.courses-aside').removeClass('show')
    $(@).removeClass('is__active')


# тут какая то добавочная информация показывается на schedule and my__courses
  $(document).on 'click', '.schedule-item .additional-info .action-btn' ,(e) ->
    $(document).trigger 'click.dropdown'
    list = $(@).find('ul.hidden-list').show()
    $('body').bind 'click.dropdown', (ev) ->
      unless e.target.closest('.action-btn') == ev.target.closest('.action-btn')
        list.hide()
        $(document).unbind 'click.dropdown'


# судя по всему что то скрывается, на клик мимо его. Заменить на стандартную
  $(document).on 'click', '.schedule-header .select-trigger', (e) ->
    $(document).trigger 'click.dropdown'
    list = $(@).closest('.psevdo-select').find('ul.hidden-list').show()
    $('body').bind 'click.dropdown', (ev) ->
      unless e.target.closest('.psevdo-select') == ev.target.closest('.psevdo-select')
        list.hide()
        $(document).unbind 'click.dropdown'


# судя по всему что то скрывается, на клик мимо его. Заменить на стандартную
  $('body').bind 'click.dropdown', (ev) ->
    unless ($(ev.target).closest('.js__toggle-state').length || $(ev.target).closest(".noCloseToggleState").length || $(ev.target).is('[class^="ui-datepicker"]'))
      hideBlock($('.js__toggle-state'))
      adaptiveTitle()
      $(document).unbind 'click.dropdown'
