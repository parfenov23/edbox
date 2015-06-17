BackboneApp.Views signup: index: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signup/index_signup']

  ui:
    button: '.auth__enter .auth__submit'

  events:
    # 'change input[name=surname]'         : 'changeSurname'
    # 'change input[name=name]'            : 'changeName'
    # 'change input[name=email]'           : 'changeEmail'
    # 'change input[name=password]'        : 'changePassword'
    # 'change input[name=password_repeat]' : 'changePasswordRepat'
    # 'change input[name=agreed]'          : 'changeCheckbox'
    'click .auth__reg-selected'          : 'openSelect'
    'click .auth__reg-select-list-item'  : 'changeSelect'
    'click .auth__submit'                : 'post'

  # changeSubdomain: (e) ->
  #   val = $(e.target).val()
  #   if val
  #     @checkSubdomain val, (callback) =>
  #       @validatedSubdomain = callback
  #       @changeInput()
  #   else
  #     @hideButton()

  # changeLogin: (e) ->
  #   val = $(e.target).val()
  #   if val
  #     @checkFunnel val, (callback) =>
  #       @validatedFunnel = callback.funnel
  #       @validatedDirector = callback.director
  #       @changeInput()
  #   else
  #     @hideButton()

  # changeCheckbox: ->
  #   @ui.button.addClass 'inactive'
  #   data = @getInput()

  #   arr = _.map data, (v, k) ->
  #     if _.isBoolean v
  #       v
  #     else if _.isString v
  #       v != ''

  #   setTimeout =>
  #     if @validatedSubdomain and (@validatedDirector or @validatedFunnel) and _.isEqual arr, [true, true, true, true]
  #       @ui.button.removeClass 'inactive'
  #     else
  #       @hideButton()
  #   , 1000

  # checkSubdomain: (subdomain, callback) ->
  #   $.ajax
  #     url: '/api/accounts/check_subdomain'
  #     data:
  #       subdomain: subdomain
  #     success: (response) =>
  #       callback response
  #       unless response
  #         # добавлять класс красненький
  #         @show_error 'Данный субдомен не был зарегистрирован в нашей системе. Пожалуйста обратитесь к ...'
  #     error: (xhr) =>
  #       callback false
  #       @show_error xhr.responseJSON.error, 5000

  # checkFunnel: (login, callback) ->
  #   $.ajax
  #     url: '/api/accounts/check_director_and_funnel'
  #     data:
  #       login: login
  #     success: (response) =>
  #       callback response
  #       unless response.director or response.funnel
  #         @show_error 'Для данного аккаунта не была настроена воронка, пожалуйста сообщите своему директору.'
  #     error: (xhr) =>
  #       callback false
  #       @show_error xhr.responseJSON.error, 5000

  # hideButton: ->
  #   @ui.button.addClass 'inactive'

  openSelect: (e) ->
    $(e.target).closest('.auth__reg-select').find('.auth__reg-select-list').addClass('active')

  changeSelect: (e) ->
    $(e.target).closest('.auth__reg-select').find('.auth__reg-selected').html(''+$(e.target).html()+'')
    $(e.target).closest('.auth__reg-select').find('.auth__reg-select-list').removeClass('active')



  post: ->
    data = _.omit @getInput(), 'agreed'
    @ui.button.addClass 'inactive'
    @show_error 'Подождите чуть-чуть!', 20000
    $.ajax
      type: 'POST'
      url: '/api/register'
      data: data
      success: (m) =>
        $.cookie('cham_key', m.cham_key)
        _.extend BackboneApp.current_user.attributes, m
        @trigger 'menu:update'
        location.href = '#signup/set_password'
      error: (xhr) =>
        response = xhr.responseJSON
        @show_error response.error, 5000
        @ui.button.removeClass 'inactive'
        location.href = '#signin' if response.user
