BackboneApp.Views signup: how_to_get: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signup/how_to_get_signup']

  # events:
  #   'click .auth__helper-ok' : 'ripple'

  # ripple: (e) ->

  #   $(e.target).find('.small-ripple').addClass('animated')
  #   e.preventDefault()

  # post: ->
  #   data = change_password: @getInput()
  #   data.change_password.registration = true

  #   $.ajax
  #     type: 'put'
  #     url: 'api/users/' + BackboneApp.current_user.get 'id'
  #     data: data
  #     success: (m) ->
  #       location.href = if m.crm_is_admin then '#director/setup/statuses' else '#profile'
