BackboneApp.Views signin: index: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signin/index_auth']

  events:
    'click #submit' : 'post'

  post: ->
    $.ajax
      type: 'POST'
      url: '/api/v1/sessions/auth'
      data: @getInput()
      success: (m) =>
        $.cookie('user_key', m.user_key)
        _.extend BackboneApp.current_user.attributes, m
        @trigger 'menu:update'
        location.href = '/cabinet'
      error: (m) =>
        @show_error m.responseJSON.error, 5000
