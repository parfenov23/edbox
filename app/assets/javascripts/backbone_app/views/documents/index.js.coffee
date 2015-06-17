BackboneApp.Views documents: layout: Backbone.Marionette.Layout.extend
  template: JST['backbone_app/templates/documents/layout']
  header:
    title: 'Основные документы'

  regions:
    side_links: "#side_links"
    container: "#container"

  initialize: ->
    @page = @model.get 'page'

  onShow: ->
    @side_links.show new BackboneApp.Views.documents.side_links model: @model
    @container.show new BackboneApp.Views.documents[@page] if @page
