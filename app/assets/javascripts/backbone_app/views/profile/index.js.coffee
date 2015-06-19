BackboneApp.Views profile: index: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/profile/profile']
  header:
    logo_ed       : true
    logo_ad       : true
    user          : true
    apps          : true
    notifications : true
    courses       : true
    headerBottom  : true

  events:
    'change input[type=checkbox]' : 'changeState'

  initialize: ->
    @setting = @model.get 'setting'

  # changeFile: (e) ->
  #   data = new FormData()
  #   data.append 'ava', @$('input[type=file]')[0].files[0]
  #   $.ajax
  #     type: 'PUT'
  #     url: '/api/users/4/update_ava'
  #     data: data
  #     cache: false
  #     contentType: false
  #     processData: false
  #     success: (data) =>
  #       @$('#userAva').attr('src', 'data:image/png;base64,' + data.base64)
  #       @changeState()
  #     error: =>
  #       @show_error 'Не удалось обновить аватар'

  # changeState: ->
  #   bool = _.isEmpty _.compact _.map @getInput(), (v, k) =>
  #     if _.isBoolean v
  #       v + '' != @setting[k]
  #     else if _.isString v
  #       v != ''

  #   @showSaveButtons !bool

  # showSaveButtons: (bool) ->
  #   btn_holder = @$('.profile__item.save-changes')
  #   return if bool and btn_holder.hasClass 'active'
  #   btn_holder.toggleClass 'active'
  #   setTimeout ->
  #     @$('.save-changes .btn').toggle bool
  #   , 300

  # getInput: ->
  #   _.extend _.object($(".profile input:not([type=checkbox])").map -> [[@name, $(@).val()]]),
  #     _.object $(".profile input[type=checkbox][name]").map -> [[@name, @checked]]

  # post: (e) ->
  #   e.preventDefault()
  #   data = @getInput()
  #   password_keys = ['old_pass', 'new_pass', 'confirm_pass']
  #   passwords = _.pick data, password_keys
  #   password_keys.push 'ava'

  #   result =
  #     setting: _.omit data, password_keys
  #     avatar: $("#userAva").attr 'src'
  #   result.change_password = passwords if passwords.new_pass == passwords.confirm_pass and passwords.new_pass != ''

  #   $.ajax
  #     type: 'PUT'
  #     url: '/api/v1/users/info'
  #     data: result
  #     success: (m) =>
  #       @show_error 'Данные обновлены'
  #       BackboneApp.current_user.set avatar: m.avatar
  #       @trigger 'header:update'
  #       location.href = '#reload'
  #     error: (resonse) =>
  #       @show_error 'Не удалось обновить данные'
