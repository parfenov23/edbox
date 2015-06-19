diff =
  statuses: 'funnel_statuses'
  managers_invite: 'directors/invited_users'
  managers_plan: 'directors/users'

router=Marionette.AppRouter.extend
  appRoutes:
    'director/analytics(/:page)' : 'analytics'
    'director/setup/:page'   : 'setup'

render = (v) ->
  BackboneApp.layout.main.show v

controller=
  analytics: (page) ->
    new Backbone.Collection()
    .setOptions url: 'api/directors/users_tasks'
    .fetch
      success: (m)->
        render new BackboneApp.Views.director.analytics[page or 'index'] model: m
      error: (m, xhr)->
        $.route_error xhr

  setup: (page) ->
    return render new BackboneApp.Views.director.setup.webhook if page == 'webhook'
    new Backbone.Model()
    .setOptions url: 'api/' + diff[page]
    .fetch
      success: (m)->
        render new BackboneApp.Views.director.setup[page] model: m
      error: (m, xhr)->
        $.route_error xhr

BackboneApp.addInitializer ->
  new router controller: controller
