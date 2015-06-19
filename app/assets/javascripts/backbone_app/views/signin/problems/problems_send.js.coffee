BackboneApp.Views signin: problems: problems_send: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signin/problems/problems_send']

  events:
    'click #submit' : 'submit'

  submit: ->
    location.href = '/#signin'
