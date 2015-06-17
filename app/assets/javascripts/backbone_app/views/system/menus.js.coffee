BackboneApp.Views system: menus: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/system/menus']

  ui:
    leftMenu     : '.header__menu'
    leftSubMenu  : '.header__menu-user-menu'

  events:
    'click a' : 'closeAll'

  modelEvents:
    'change' : 'update'

  initialize: (options) ->
    @model = BackboneApp.current_user
    @listenTo options.watch, 'show', (view) =>
      @show_tabs = view.header?.tabs?
      @listenToTabs @show_tabs

  onShow: ->
    @closeAll()
    @clickClose()
    @keyAction()

  changeLeft: ->
    hasClass = @ui.leftMenu.hasClass 'active'
    setTimeout =>
      if hasClass
        @ui.leftMenu.removeClass 'active'
      else
        @ui.leftMenu.addClass 'active'

  listenToTabs: (bool = false) ->
    if bool
      @$('.header__activity-settings-menu, .header__menu').addClass 'lower'
    else
      @$('.header__activity-settings-menu, .header__menu').removeClass 'lower'

  keyAction: ->
    $(window).keydown (e) =>
      code = e.keyCode || e.which
      @closeAll() if code == 27

  removeDisabledLinks: ->
    _.each @$('.header__menu-item.disabled'), (el) ->
      el.removeAttribute 'href'

  clickClose: (e) ->
    $(document).on 'click', (e) ->
      firstClick = false
      userMenu = $(e.target).closest('.header__menu').length == 0
      if !firstClick and userMenu
        $('.header__menu').removeClass 'active'

  closeAll: ->
    @ui.leftMenu.removeClass 'active'

  update: ->
    @render()
    @listenToTabs @show_tabs
    @removeDisabledLinks()
