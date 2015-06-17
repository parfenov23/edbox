BackboneApp.Views signin: index: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signin/index_auth']

  events:
    'click #submit' : 'post'

  post: ->
    $.ajax
      type: 'POST'
      url: '/api/auth'
      data: @getInput()
      success: (m) =>
        $.cookie('cham_key', m.cham_key)
        _.extend BackboneApp.current_user.attributes, m
        @trigger 'menu:update'
        location.href = '#profile'
      error: (m) =>
        @show_error m.responseJSON.error, 5000
