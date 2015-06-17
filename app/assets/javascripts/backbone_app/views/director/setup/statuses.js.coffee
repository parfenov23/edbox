# Список листов для dragndrop
connectedListsArray = '.status, .dropzone'

BackboneApp.Views director: setup: statuses: BackboneApp.Views.director.setup.wrapper.extend
  template: JST['backbone_app/templates/director/setup/statuses']
  page: 'statuses'
  className: 'director_settings'

  events:
    'click .delete'        : 'deleteStatus'
    'click .plus'          : 'addDropzone'
    'click .toggle'        : 'innerToggle'
    # 'mouseout .right.drag' : 'removePlaceholder'
    'click #post'          : 'post'

  initialize: ->
    used_statuses = @model.get 'used_statuses'
    unused_statuses = @model.get 'unused_statuses'
    funnel_types = @model.get 'funnel_types'
    @all_statuses = used_statuses.concat unused_statuses
    _.each funnel_types, (type) ->
      type.positions = {}
      type_statuses = _.filter used_statuses, (status) -> status.funnel_type_id == type.id
      positions = _.uniq _.map type_statuses, (status) -> status.position
      positions = [1] if _.isEmpty positions
      _.each positions, (position) ->
        type.positions[position] = _.filter type_statuses, (status) -> status.position == position

    @first_setup = used_statuses.length == 0
    @model.set
      all_statuses: @all_statuses
      funnel_types: funnel_types
      first_setup: @first_setup

  onShow: ->
    _.each @$('.status__item '), (el) ->
      $(el).find('.circle, .circle i').css({'background':$(el).attr 'data-color'})
    @moveButtons()
    @dragndrop()
    @paintStatus()

  # Раскрасить статусы
  paintStatus: ->
    _.each @$('.dropzone .status__item '), (el) ->
      $(el).css({'background':$(el).attr 'data-color'})



  # Кнопки всегда внизу окна
  moveButtons: ->
    $(window).scroll ->
      parent = $('.bottom')
      parentHeight = parent.outerHeight()
      parentPos = parent.offset().top
      elem = $('.btn__holder')
      elemHeight = elem.outerHeight()
      elemPos = elem.offset().top
      headerHeight = $('.header__holder').outerHeight()
      windowPos = $(document).scrollTop()
      documentHeight = $(document).outerHeight()
      windowHeight = $(window).outerHeight()

      # СУКА Я ЗАЕБАЛСЯ ЛОМАТЬ ГОЛОВУ КАК ЭТО СДЕЛАТЬ!!!!!




  # Драгндроп статусов
  dragndrop: ->
    @$(connectedListsArray).sortable(
      connectWith: [ connectedListsArray ]
      items: '.status__item'
      cancel: '.ui-state-disabled, .used'
      placeholder: 'ui-state-placeholder'
      scroll: false
      zIndex: 9999
      dropOnEmpty: true
      start: (event, ui) =>
        if !ui.item.closest('.dropzone').length > 0
          parent = ui.item.parent()
          ui.item.clone(true).appendTo parent
        ui.item.addClass 'dragging'
        @$('.status, .funnel__holder').addClass 'dragging'
      beforeStop: (event, ui) =>
        @$('.status, .funnel__holder').removeClass 'dragging'
      stop: (event, ui) =>
        elem = ui.item[0].className.split(' ')[2]
        $('.status').find('.' + elem + '').addClass 'used'
        ui.item.addClass('ui-state-disabled')
        @paintStatus()
        @showButton()
    ).disableSelection()

  # Убираем плейсхолдер из правого списка по mouseleave
  removePlaceholder: (e) ->
    $(e.target).find('.ui-state-placeholder').remove()

  # Удаление статуса
  deleteStatus: (e) ->
    @showButton()
    target = $(e.target).closest('.status__item')
    targetParent = $(e.target).closest('.dropzone')
    itemsLength = targetParent.find('.status__item').length - 1
    wasItemsLength = itemsLength + 1
    id = target.attr('data-id')
    target.detach()
    $('.status').find('.' + id + '').removeClass 'used'

  # Добавляем поле для дропа
  addDropzone: (e) ->
    parent = $(e.target).closest('.funnel').find('div.left')
    index = parseInt(parent.find('.dropzone:last').attr('data-line')) + 1
    parent.append '<div class="dropzone dropzone-line-' + index + ' ui-sortable" data-line="' + index + '"></div>'
    @dragndrop()

  post: ->
    form = @$('.funnel__holder').children()
    result = {}
    _.each form, (type_funnel) ->
      tf = $(type_funnel)
      dropzones = tf.find('.left .dropzone')
      _.each dropzones, (dropzone, dropzone_index) ->
        dz = $(dropzone)
        statuses = dz.find('.status__item')
        unless statuses.length == 0
          _.each statuses, (status) ->
            result[$(status).data('id').split('-')[1]] =
              funnel_type_id: tf.data('id')
              position: dz.data('line')

    return @show_error 'Вы не использовали все статусы' unless _.size(result) == _.size(@all_statuses)

    $.ajax
      type: 'POST'
      url: '/api/directors/save_funnel_type'
      data:
        result: result
      success: (response) =>
        @ajax_success @first_setup, 'managers_invite'
      error: (xhr) =>
        @route_error xhr
