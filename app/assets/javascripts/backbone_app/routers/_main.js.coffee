diff =
  profile: 'v1/users/info'
  tasks: 'tasks/index_new'

router = Marionette.AppRouter.extend
  appRoutes:
    'reload'       : 'reload'
    ':page'        : 'main'

render = (v) ->
  BackboneApp.layout.main.show v

controller=
  main: (page) ->
    location.href="/cabinet" if page == 'profile'
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
