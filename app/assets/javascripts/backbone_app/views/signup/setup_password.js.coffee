BackboneApp.Views signup: set_password: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signup/signup_set_password']

  events:
    'click .auth__submit' : 'post'

  post: ->
    data = change_password: @getInput()
    data.change_password.registration = true

    $.ajax
      type: 'put'
      url: 'api/users/' + BackboneApp.current_user.get 'id'
      data: data
      success: (m) ->
        location.href = if m.director then '#director/setup/statuses' else '#profile'
