diff =
  profile: 'users/current'
  tasks: 'tasks/index_new'

router = Marionette.AppRouter.extend
  appRoutes:
    'reload'       : 'reload'
    ':page'        : 'main'

render = (v) ->
  BackboneApp.layout.main.show v

controller=
  main: (page) ->
    unless page in ['profile', 'tasks']
      return console.log 'render 404'
    new Backbone.Model()
    .setOptions url: '/api/' + diff[page]
    .fetch
      success: (m)->
        render new BackboneApp.Views[page]['index'] model: m
      error: (m, xhr)->
        $.route_error xhr

  reload: ->
    history.back()

BackboneApp.addInitializer ->
  new router controller: controller
