BackboneApp.Views oferta: index: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/oferta/index']
  className: 'oferta_holder'
  header: false

  events:
    'click .back'   : 'goBackToReg'
    'click #submit' : 'ofertaAgree'

  goBackToReg: () ->
    location.href = '/#signup'

  ofertaAgree: () ->
    location.href = '/#signup?agreed=true'
