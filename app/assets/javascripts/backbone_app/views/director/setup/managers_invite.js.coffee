BackboneApp.Views director: setup: managers_invite: BackboneApp.Views.director.setup.wrapper.extend
  template: JST['backbone_app/templates/director/setup/managers_invite']
  className: 'director_settings'
  page: 'managers_invite'

  events:
    'click .toggle'                     : 'innerToggle'
    'click .checkbox:not(.select__all)' : 'checkUser'
    'click .select__all'                : 'checkAll'
    'click #post'                       : 'post'

  initialize: ->
    users = @model.get 'users'

    @first_setup = _.compact _.map users, (u) ->
      u.invited
    .length == 0

    @model.set first_setup: @first_setup

  countUser: (bool = false) ->
    count = @$('.checkbox.active').length
    count -= 1 if bool
    @$('.chosen #count').html count

  ### Делаем кликнутые поля цветными ###
  checkUser: (e) ->
    @showButton()
    target = $(e.target)
    if target.hasClass('active')
      target.removeClass 'active'
      target.closest('.item').removeClass 'active'
      @$('.select__all').removeClass('active').prop 'checked', false
    else
      target.addClass 'active'
      target.closest('.item').addClass 'active'
    @countUser()

  ### Выделить всех людей (чекбоксы) ###
  checkAll: (e) ->
    @showButton()
    target = $(e.target)

    if target.hasClass 'active'
      target.removeClass('active').prop 'checked', false
      @$('.bottom .list .item').removeClass('active').find('.checkbox').removeClass('active').prop 'checked', false
    else
      target.addClass('active').prop 'checked', true
      _.each @$('.bottom .list .item'), (el) ->
        unless el.className.split(' ')[1] == 'active'
          $(el).addClass('active').find('.checkbox').addClass('active').prop 'checked', true

    @countUser target.hasClass('active')

  post: ->
    $.ajax
      type: 'post'
      url: '/api/directors/invite_users'
      data:
        users: @getInput()
      success: (m) =>
        @ajax_success @first_setup, 'managers_plan'
      error: (xhr) =>
        @route_error xhr
