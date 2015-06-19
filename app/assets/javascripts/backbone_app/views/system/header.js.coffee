tabs = JST['backbone_app/templates/system/header_bottom']

BackboneApp.Views system: header: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/system/header']
  className: 'header'

  ui:
    logo_ed       : '.logo.logo__ed'
    logo_ad       : '.logo.logo__ad'
    user          : '.header__user'
    apps          : '.header__apps'
    notifications : '.header__notifications'
    courses       : '.header__courses'
    headerBottom  : '.header__bottom'


  events:
    'mouseenter .header__tabs-menu-item'    : 'tabHoverOn'

  modelEvents:
    'change' : 'update'

  initialize: (options)->
    @model = BackboneApp.info
    @listenTo options.watch, 'show', (view) ->
      @redrawHeader view


  onShow: ->

  redrawHeader: (view) ->
    if hsh = view.header
      @$el.show()
    else
      @$el.hide()
