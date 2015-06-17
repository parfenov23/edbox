@BackboneApp = do (Backbone, Marionette) ->

  App = new Marionette.Application

  root_url = if $.cookie('cham_key') then '#profile' else '#signin'
  App.rootRoute = root_url

  App.on "initialize:after", ->
    @startHistory()
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()

  App
