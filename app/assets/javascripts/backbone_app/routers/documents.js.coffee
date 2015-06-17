router=Marionette.AppRouter.extend
  appRoutes:
    'documents(/:page)' : 'page'

render = (v) ->
  BackboneApp.layout.main.show v

controller=
  page: (page) ->
    new Backbone.Model()
    .setOptions url: "/documents"
    .fetch
      data:
        page: page if page
      success: (m)->
        render new BackboneApp.Views.documents.layout model: m
      error: (m, xhr)->
        $.route_error xhr

BackboneApp.addInitializer ->
  new router controller: controller
