BackboneApp.Views system: restore_password: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/system/restore_password']

  events:
    'submit #restore_password_form' : 'post'

  post: (e) ->
    e.preventDefault()
    data = @getInput()
    data.key = window.location.href.match('key=([^&]+)&?')?[1]
    data.login = window.location.href.match('login=([^&]+)&?')?[1]

    $.ajax
      type: 'PUT'
      url: 'api/users/update_password'
      data: data
      success: (m) ->
        location.href = '#signin'
      error: (m) =>
        @show_error m.responseJSON.error, 5000
