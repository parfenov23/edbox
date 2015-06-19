BackboneApp.Views signin: problems: problems: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/signin/problems/index_problems']

  events:
    'click #cancel' : 'cancel'
    'click #submit' : 'submit'

  cancel: ->
    location.href = '/#signin'

  submit: ->
    location.href = '/#signin/problems_send'
