view = Backbone.Marionette.Layout.extend
  el: 'body'
  template: JST['backbone_app/templates/system/layout']

  regions:
    header: '#header__holder'
    menus: '#menus'
    main: '#main'
    # help: '#help'

  onRender: ->
    @listenTo @header, 'show', @menuesTriggers
    @listenTo @main, 'show', @mainTriggers
    @header.show new BackboneApp.Views.system.header watch: @main
    @menus.show new BackboneApp.Views.system.menus watch: @main
    # @help.show new BackboneApp.Views.system.help

  menuesTriggers: (view) ->
    @listenTo view, 'menu:show:left', -> @menus.currentView?.changeLeft()
    @listenTo view, 'menu:close:all', -> @menus.currentView?.closeAll()
    @listenTo view, 'close', -> @stopListening view

  mainTriggers: (view) ->
    @listenTo view, 'menu:update', -> @menus.currentView?.update()
    @listenTo view, 'header:update', -> @header.currentView?.update()
    @listenTo view, 'close', -> @stopListening view


BackboneApp.addInitializer ->
  BackboneApp.layout = new view().render()
