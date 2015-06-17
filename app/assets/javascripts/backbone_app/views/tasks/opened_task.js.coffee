dropdown_list = JST['backbone_app/templates/tasks/dropdown_list']
dropdown_list_task = JST['backbone_app/templates/tasks/dropdown_list_task']

default_ab = JST['backbone_app/templates/tasks/action_block/default_ab']
edit_task_ab = JST['backbone_app/templates/tasks/action_block/edit_task_ab']
confirm_action_ab = JST['backbone_app/templates/tasks/action_block/confirm_action_ab']
edit_comment_ab = JST['backbone_app/templates/tasks/action_block/edit_comment_ab']

today_date = new Date

actionTitle =
  create: 'Создать задачу'
  change_status: 'Перевести сделку в статус'
  add_comment: 'Добавить комментарий'

taskTitle =
  create: 'Встретиться'
  change_status: 'Написать письмо'
  add_comment: 'Позвонить'

dayline =
  today: 'Сегодня'
  tomorrow: 'Завтра'
  monday: 'В понедельник ' + $.next_monday today_date
  twoWeeks: 'Через 2 недели ' + $.date_plus_two_weeks today_date
  chooseDate: 'Выбрать дату'

timeLine =
  morning: 'в 11:00'
  dinner: 'в 14:00'
  evening: 'в 16:00'
  chooseTime: 'Выбрать время'

BackboneApp.Views tasks: opened_task: Backbone.Marionette.Layout.extend
  template: JST['backbone_app/templates/tasks/opened_task']
  className: 'open-state'

  regions:
    planned: '.planned_actions'
    today: '.today_activity'

  events:
    'click .action-btns .more'       : 'openInfo'
    'click .visible-wrp .add-task i' : 'addTask'
    'click .visible-wrp .add-comment': 'addNote'
    'focus .js__main-action-input'   : 'showList'
    'focus .js__task-action-input'   : 'showListTask'
#    'blur .js__task-action-input'    : 'changeListTask'
    'blur .js__main-action-input'    : 'changeListTask'
    'keyup .js__main-action-input'   : 'parseType'
    'keyup .js__task-action-input'   : 'parseTypeTask'
    'click .select-trigger'          : 'choseValue'
    'click .js_psevdo-select'        : 'showValue'
    'click .result-list li'          : 'choice'
    'click .datapicker__trigger'     : 'showDatePicker'
    'click .mega-btn.edit-task'      : 'postMegaTask'
    'click > .title'                 : 'closeIt'
    'click .mega-btn.add-comment'    : 'addComment'
    'click .mega-btn.default-btn'    : 'addWhat'
    'click .add-comment'             : 'showCommeent'

  ui:
    action_block: '.super-mega-search-2000'

  addWhat: (e) ->
    text = @$('.js__main-action-input').text()
    switch
      when text.indexOf 'Перевести сделку в статус' > -1
        return unless status_name = text.split('Перевести сделку в статус ')[1]
        status = _.filter @model.get('statuses'), (s) -> s.name == status_name
        return if _.isEmpty status
        @confirmAction "перевести сделку в статус #{status_name}", (flag) =>
          @model.save status_id: status[0].crm_id,
            success: (m) =>
              @show_error 'Сделка переведена в новый статус'
              @rerender()
              @trigger 'chage:lead', status[0].color
            error: (xhr) => @show_error 'Ошибка. Сделка не переведена в новый статус'

  initialize: ->
    @model.set today_date: today_date


  onRender: ->
    @listenTo @planned, 'show', @taskEvents
    @listenTo @today, 'show', @taskEvents

  taskEvents: (view) ->
    @listenTo view, 'compositeview:edit:task', (model, target) ->
      switch target.data 'type'
        when 'edit'
          hsh = _.pick model.toJSON(), ['complete_till', 'content', 'id', 'task_type']
          hsh.today_date = today_date
          hsh.task_types = @model.get 'task_types'
          @fadeInSearch edit_task_ab hsh
        when 'finish'
          @confirmAction 'завершить задачу', (flag) =>
            model.save status: 1,
              success: (m) => @show_error 'Задача закрыта'; @rerender()
              error: (xhr) => @show_error 'Ошибка. Задача не закрыта'
        when 'change_date'
          n = switch target.data 'date'
            when 'tomorrow' then 1
            when 'after_tomorrow' then 2
            when 'week' then 7
            when 'month' then 30
          new_date = new Date(Date.parse(today_date) + 86400000 * n)
          @confirmAction "перенести задачу на #{$.short_date new_date}", (flag) =>
            model.save complete_till: new_date,
              success: (m) => @show_error 'Время выполнения перенесено'; @rerender()
              error: (xhr) => @show_error 'Ошибка. Время выполнения задачи не перенесено'
        when 'choose_date'
          hsh = _.pick model.toJSON(), ['complete_till', 'content', 'id', 'task_type']
          hsh.today_date = today_date
          hsh.task_types = @model.get 'task_types'
          hsh.change_time = true
          @fadeInSearch edit_task_ab hsh

    @listenTo view, 'compositeview:edit:note', (hsh) ->
      @fadeInSearch edit_comment_ab hsh

    @listenTo view, 'close', -> @stopListening view

  sticky: (res, elem) ->
    cssP =
      'left': @$el.offset().left + 'px'
      'width': @$el.width() + 'px'
    if res == 'zero'
      attr = if elem == '.title' then 'paddingTop' else 'paddingBottom'
      @$el.css attr, '0'
      @$(elem).removeClass('js__absolute-to-btm js__fixed-to-top js__fixed-to-btm js__absolute-to-top').removeAttr 'style'
    else if res == 'fix'
      if elem == '.title'
        @$el.css 'paddingTop', '64px'
        @$('.title').removeClass('js__absolute-to-btm').addClass('js__fixed-to-top').css cssP
      else
        @$el.css 'paddingBottom', '64px'
        @$(elem).removeClass('js__absolute-to-top').addClass('js__fixed-to-btm').css cssP

  onShow: ->
    @model.setOptions url: '/api/leads/' + @model.id + '?task_types=true'
    @showRegions @model

    currPosT = @$el.offset().top - 64
    winHeight = $(window).height()
    $(document).on 'scroll', =>
      top = $(document).scrollTop()
      switch
        when currPosT > top && (currPosT + 64 + @$el.outerHeight()) < (top + winHeight) # возвращаем в первоначальное состояние
          @sticky('zero', '.title')
          @sticky('zero', '.super-mega-search-2000')
        when currPosT < top && (currPosT + 64 + @$el.outerHeight()) > (top + winHeight) # скрыты и верх и низ
          @sticky('fix', '.title')
          @sticky('fix', '.super-mega-search-2000')
        when currPosT < top && currPosT + ((@$el.outerHeight()) - 64) < top   # скрыта верхняя часть
          @$('.title').removeClass('js__fixed-to-top').addClass('js__absolute-to-btm').removeAttr 'style' #сменили с фикседа на абсолют
          @$('ul.result-list').addClass 'hide'
        when currPosT < top # скрыта верхняя часть
          @sticky('fix', '.title')
          @sticky('zero','.super-mega-search-2000')
        when (currPosT + 64 + @$el.outerHeight()) > (top + winHeight) && top + winHeight < currPosT + 128 # скрыта нижняя часть
          @$('.super-mega-search-2000').addClass('js__absolute-to-top').removeClass('js__fixed-to-btm').removeAttr 'style'
        when (currPosT + 64 + @$el.outerHeight()) > (top + winHeight) # скрыта нижняя часть
          @sticky('fix','.super-mega-search-2000')
          @sticky('zero','.title')

  showRegions: (m) ->
    @planned.show new planned_actions model: m
    @today.show new today_activity model: m
    @ui.action_block.removeClass('withPadding').html default_ab

  openInfo: ->
    @$('.hidden-info').toggleClass 'hide'

  addTask: (e) ->
    @fadeInSearch edit_task_ab task_types: @model.get 'task_types'

  addNote: ->
    @fadeInSearch edit_comment_ab

  fadeInSearch: (template) ->
    parentBlock = @$('.super-mega-search-2000')
    parentBlock.html(template).addClass 'withPadding'
    setTimeout ->
      parentBlock.find('.action__block').fadeIn 100
      $.custom_datepicker @$('.datapicker__trigger')

  showDatePicker: (e) ->
    target = $(e.target)
    calendar = $('#ui-datepicker-div')
    relX = e.pageX
    relCY = target.offset().top
    relCX = target.offset().left
    calendar.prepend '<div class="today-holder"><span>Завтра</span></div>'
    calendar.css
      'left': relCX + 'px'
      'top': relCY + 'px'
    calendar.removeClass 'hide'

  showList: (e) ->
#    target = $ e.target
#    target.text('') if target.text() == 'Что сделать'
    @$('ul.result-list').html dropdown_list({actionTitles: actionTitle})
    @$('ul.result-list').removeClass 'hide'

  showListTask: (e) ->
    target = $ e.target
    target.text('') if target.text() == 'Что сделать'
    return
    @$('ul.task-action-list').html dropdown_list({actionTitles: taskTitle})
    @$('ul.task-action-list').removeClass 'hide'

  changeListTask:  ->
    @$('.result-list').addClass 'hide'
#    console.log @$('.result-list')
#    target = $ e.target
#    target.text('Что сделать') if target.text() == ''

  parseType: (e) ->
    @commonParseType e, actionTitle, 'result-list'



  parseTypeTask: (e) ->
      @commonParseType e, taskTitle, 'task-action-list'




  commonParseType: (e, title, cls) ->
    inp = $(e.target)
    val = inp.text()
    actionBlock = inp.closest '.super-mega-search-2000'
    if val
      inp.addClass 'notEmpty'
      _.each title, (itm, type) ->
        if itm.indexOf(val) >= 0
          actionBlock.find(".#{cls} li[data-type=#{type}]").show 300
        else
          actionBlock.find(".#{cls} li[data-type=#{type}]").hide 300
          if actionBlock.find(".#{cls} li:visible").length
            console.log actionBlock.find(".#{cls} li:visible").length
    else
      inp.removeClass 'notEmpty'
      actionBlock.find(".#{cls} li").show 300

  choseValue: (e) ->
    $(document).trigger 'click.dropdown'
    list = $(e.target).closest('.select').find('ul.hidden').show()
    $(document).bind 'click.dropdown', (ev) ->
      unless e.target == ev.target
        list.hide()
        $(document).unbind 'click.dropdown'

  showValue: (e) ->
    thisEl = $ e.target
    parentBlock = thisEl.closest '.select'
    thisEl.closest('.select').find('input').val thisEl.data('type') or thisEl.text()
    parentBlock.find('.select-trigger').text thisEl.text()
    parentBlock.css('width', '50px') if parentBlock.hasClass 'time'
    parentBlock.find('.hidden').fadeOut 300

  showCommeent: ->
    @fadeInSearch edit_comment_ab

  choice: (e) ->
    thisEl = $(e.target)
    text = thisEl.text()
    actionType = thisEl.data 'type'
    changebleBlock = @ui.action_block.find '.mega_input .input'
    changebleBlock.text text
    switch
      when actionType == 'create'
        @fadeInSearch edit_task_ab task_types: @model.get 'task_types'
        $.custom_datepicker @$('.datapicker__trigger')
      when actionType == 'change_status'
        statuses = {}
        _.each @model.get('statuses'), (s) ->
          statuses[s.id] = s.name
        @$('ul.result-list').html dropdown_list forward: 'Перевести сделку в статус', actionTitles: statuses
      when actionType == 'add_comment'
        @fadeInSearch edit_comment_ab
      when actionType in ['monday', 'today']
        console.log _.keys(dayline)
      when _.isNumber actionType
        @$('ul.result-list').html actionTitle

  postMegaTask: (e) ->
    target = $ e.target
    block = target.closest('.action__block')
    data = @getData()
    return @show_error 'Выберите дату' unless data.date
    return @show_error 'Выберите время' if data.time == 'Выберите время'
    id = block.data 'id'
    result =
      element_id: @model.get 'crm_id'
      element_type: 2
      task_type: data.task_type
      text: block.find('.js__task-action-input').text()
      complete_till: $.makeDateTime data.date, if data.time == 'Весь день' then '23:59' else data.time

    model = new Backbone.Model(id: id if id)
    .setOptions urlRoot: '/api/tasks'

    model.save result,
      success: (m) =>
        @show_error 'Данные успешно сохранены'
        @rerender()
      error: =>
        @show_error 'Ошибка. изменения не сохранены'

  addComment: (e) ->
    workBlock = @$ '.action__block'
    note_id = workBlock.data('id')

    if workBlock.data 'id'
      url = '/api/notes/' + note_id
      method = 'PUT'
    else
      url = '/api/notes'
      method = 'POST'

    data =
      element_id: @model.get 'crm_id'
      element_type: 2
      note_type: 4
      text: @$('.js__task-action-input').val()

    $.ajax
      type: method
      url: url
      data: data
      success: (response) =>
        @show_error 'Данные успешно сохранены'
        @rerender()

  getData: ->
    _.object(@$(':input[name]').map -> [[@name, $(@).val()]])

  confirmAction: (str, callback) ->
    template = $ confirm_action_ab text: str
    template.find('.btn-no').on 'click', =>
      @ui.action_block.removeClass('withPadding').html default_ab
    template.find('.btn-yes').on 'click', =>
      @ui.action_block.removeClass('withPadding').html default_ab
      callback true
    @fadeInSearch template

  rerender: ->
    @model.fetch
      success: (m) =>
        @render()
        @showRegions m

  closeIt: (e) ->
    return if $(e.target).closest('.action-btns, .hidden-info').length != 0
    @trigger 'close:open:state'

  onClose: ->
    $(window).unbind('scroll')

taskItem = Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/tasks/opened_task_list_item']
  tagName : 'li'
  className: 'list-item'

  events:
    'click .action'          : 'showTaskAction'
    'click .action-category' : 'launchTaskAction'
    'click .choose-time'     : 'chooseTime'

  initialize: ->
    @model.set today_date: today_date

  showTaskAction: (e) ->
    $(document).trigger 'click.myEvent'
    list = $(e.target).find('.list-wrp').show()
    $(document).bind 'click.myEvent', (ev) ->
      unless e.target == ev.target
        list.hide()
        $(document).unbind 'click.myEvent'

  launchTaskAction: (e) ->
    switch @model.get('type')
      when 'Task'
        @model.setOptions urlRoot: '/api/tasks'
        @chooseTime e
      when 'Note'
        @trigger 'noteitem:trigger', _.pick @model.toJSON(), ['content', 'id']
        @$el.fadeOut 300

  chooseTime: (e) ->
    @trigger 'edit:task', @model, $ e.target

planned_actions = Backbone.Marionette.CompositeView.extend
  template: _.template("<div class='l-header'>Запланированные действия<span class='show-all'>Посмотреть всю историю</span></div><ul>")
  itemView: taskItem
  itemViewContainer: 'ul'

  initialize: ->
    if _.isEmpty arr = @model.get 'planned_activities'
      @$el.hide()
    else
      @collection = new Backbone.Collection arr

  onRender: ->
    @children.each _.bind (childView) =>
      @listenTo childView, 'edit:task', (model, action) =>
        @trigger 'compositeview:edit:task', model, action
      @listenTo childView, 'noteitem:trigger', (hsh) =>
        @trigger 'compositeview:edit:note', hsh

today_activity = Backbone.Marionette.CompositeView.extend
  template: _.template("<div class='l-header'>Активность сегодня</div><ul>")
  itemView: taskItem
  itemViewContainer: 'ul'

  initialize: ->
    if _.isEmpty arr = @model.get 'today_activities'
      @$el.hide()
    else
      @collection = new Backbone.Collection arr

  onRender: ->
    @children.each _.bind (childView) =>
      @listenTo childView, 'edit:task', (model, action) =>
        @trigger 'compositeview:edit:task', model, action
      @listenTo childView, 'noteitem:trigger', (hsh) =>
        @trigger 'compositeview:edit:note', hsh
