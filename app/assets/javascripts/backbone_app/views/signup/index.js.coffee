BackboneApp.Views signup: index: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signup/index_signup']

  ui:
    button: '.auth__enter .auth__submit'

  events:
    'change input[name=last_name]'       : 'changeRegInput'
    'change input[name=first_name]'      : 'changeRegInput'
    'change input[name=email]'           : 'changeRegInput'
    'change input[name=password_repeat]' : 'changeRegInput'
    'change input[name=password]'        : 'changePassword'
    'change input[name=password_repeat]' : 'changePassword'
    'click .auth__reg-selected'          : 'openSelect'
    'click .auth__reg-select-list-item'  : 'changeSelect'
    'change input[name=corporate]'       : 'changeRegInput'
    'change input.corporate_acc'         : 'changeRegInput'
    'change input[name=agreed]'          : 'changeRegInput'
    'click .auth__submit'                : 'validate'
    'keyup input.error'                 : 'changeErrorInput'

  onShow: ->
    agreed = location.href.split('?agreed=')[1]?
    if agreed
      @$('.checkbox__holder .label').click()
      Backbone.history.navigate('signup')


  changeRegInput: (e) ->
    if $(e.target).val()
      @getInput()

  changeErrorInput: (e) ->
    if $(e.target).val()
      $(e.target).removeClass('error')
      @getInput()
    else
      $(e.target).addClass('error')


  changePassword: (e) ->
    pass = @$('input[name=password]').val()
    pass_repeat = @$('input[name=password_repeat]').val()
    if pass == pass_repeat
      @$('input[name=password_repeat]').removeClass('error')
      @getInput()
    else
      @$('input[name=password_repeat]').addClass('error')


  openSelect: (e) ->
    $(e.target).closest('.auth__reg-select').find('.auth__reg-select-list').addClass('active')

  changeSelect: (e) ->
    if $(e.target).hasClass('corporate')
      $('.corporate_acc').addClass('active')
      $('input[name=corporate]').val('true')
    else
      !$('.corporate_acc').removeClass('active')
      $('input[name=corporate]').val('')
    $(e.target).closest('.auth__reg-select').find('.auth__reg-selected').html(''+$(e.target).html()+'')
    $(e.target).closest('.auth__reg-select').find('.auth__reg-select-list').removeClass('active')



  validate: ->
    _.each @$('input') , (el) ->
      if !$(el).val()
        $(el).addClass('error')

    if !$('input.checkbox').is(':checked')
      $('input.checkbox').addClass('error')

    data = @getInput()

    arr = _.map data, (v, k) ->
      if _.isBoolean v
        v
      else if _.isString v
        v != ''

    setTimeout =>
      if _.isEqual arr, [true, true, true, true, true, true, true]
        @post()
      else if _.isEqual arr, [true, true, true, false, true, true, true]
        @post()
      else
        @show_error 'Заполните все поля', 5000
    , 1000


  post: ->
    data = @getInput()
    user = _.omit data, 'password_repeat', 'agreed', 'name'
    company = _.pick data, 'name'
    console.log user, company
    @show_error 'Подождите чуть-чуть!', 5000
    $.ajax
      type: 'POST'
      url: '/api/v1/sessions/registration'
      data:
        user: user
        company: company
      success: (m) =>
        $.cookie('user_key', m.user_key)
        # _.extend BackboneApp.current_user.attributes, m
        # @trigger 'menu:update'
        location.href = '#profile'
      error: (xhr) =>
        response = xhr.responseJSON
        @show_error response.error, 5000
        location.href = '#signin' if response.user
