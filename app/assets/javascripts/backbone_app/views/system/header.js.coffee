tabs = JST['backbone_app/templates/system/header_tabs']

BackboneApp.Views system: header: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/system/header']

  ui:
    title:     '.header__title'
    hamburger: '.header__menu-icon-holder'
    actions:   '.header__activity'
    tabs:      '.header__tabs'
    rightUser: '.header__activity-profile-menu'
    rightApps: '.header__apps'
    name:      '.info .name'
    login:     '.info .login'
    avatars:   '.header__activity-profile-img, .ava'

  events:
    'mouseenter .header__tabs-menu-item'    : 'tabHoverOn'
    'mouseleave .header__tabs-menu-item'    : 'tabHoverOff'
    'click .header__menu-icon'              : 'showLeftMenu'
    'click .header__activity-apps'          : 'showApps'
    'click .header__activity-profile-img'   : 'showUserMenu'
    'click .header__tabs-menu-item'         : 'changeTab'
    'click .header'                         : 'closeMenus'
    'click .icon.header__activity-apps'     : 'closeMenus'

  modelEvents:
    'change' : 'update'

  initialize: (options)->
    @model = BackboneApp.current_user
    @listenTo options.watch, 'show', (view) ->
      @show_tabs = view.header?.tabs?
      @listenToTabs @show_tabs
      @redrawHeader view

  onShow: ->
    @clickClose()

  listenToTabs: (bool = false) ->
    if bool
      @$('.header__apps, .header__activity-profile-menu').addClass 'lower'
    else
      @$('.header__apps, .header__activity-profile-menu').removeClass 'lower'

  clickClose: (e) ->
    $(document).on 'click', (e) ->
      userMenu = $(e.target).closest('.header__activity-profile-menu').length == 0
      userApps = $(e.target).closest('.header__apps').length == 0
      if userMenu
        $('.header__activity-profile-menu').removeClass 'active'
      if userApps
        $('.header__apps').removeClass 'active'

  tabHoverOn: (e) ->
    $('<div class="header__tabs-line header__tabs-line-hover"></div>').appendTo e.target

  tabHoverOff: (e) =>
    @$(e.target).find('.header__tabs-line').remove()

  showUserMenu: (e) ->
    @rippleTarget e, @$(e.target)
    hasClass = @ui.rightUser.hasClass 'active'
    setTimeout =>
      if hasClass
        @ui.rightUser.removeClass 'active'
      else
        @closeDropdowns()
        @ui.rightUser.addClass 'active'

  showApps: (e) ->
    @rippleTarget e, @$(e.target)
    hasClass = @ui.rightApps.hasClass 'active'
    setTimeout =>
      if hasClass
        @ui.rightApps.removeClass 'active'
      else
        @closeDropdowns()
        @ui.rightApps.addClass 'active'

  # changeNotifications: ->
  #   hasClass = @ui.rightNotifications.hasClass 'active'
  #   setTimeout =>
  #     if hasClass
  #       @ui.rightNotifications.removeClass 'active'
  #     else
  #       @ui.rightNotifications.addClass 'active'

  redrawHeader: (view) ->
    if hsh = view.header
      if hsh.title then @ui.title.html hsh.title else @ui.title.html 'Chameleon'
      if hsh.hamburger then @ui.hamburger.show() else @ui.hamburger.hide()
      if hsh.actions then @ui.actions.show() else @ui.actions.hide()
      if hsh.tabs
        return if @tabs == hsh.tabs
        @tabs = hsh.tabs
        @ui.tabs.html tabs links: hsh.tabs, active: view.page
        @initialMarker()
      else
        @tabs = null
        @ui.tabs.html ''
      @$el.show()
    else
      @$el.hide()

  showLeftMenu: (e) ->
    @rippleTarget e, '.header__menu-icon-holder'
    @trigger 'menu:show:left'

  changeTab: (e) ->
    @$('.header__tabs-line-hover').remove()
    @$('.header__tabs-menu-item').removeClass 'active'
    currentTab = @$('.header__tabs-menu-item.active')
    currentTab.removeClass 'active'
    selectTab = $(e.target)
    selectTabOffset = selectTab.position().left
    selectTabWidth = selectTab.outerWidth() + 46
    selectTab.addClass 'active'
    @$('.header__tabs-line').animate({'left':selectTabOffset+'px','width':selectTabWidth+'px'},300)

  initialMarker: ->
    currentTab = $('.header__tabs-menu-item.active')
    currentTabOffset = currentTab.position().left
    currentTabWidth = currentTab.outerWidth() + 46
    @$('.header__tabs-line').css({'left':currentTabOffset+'px','width':currentTabWidth+'px'})

  # showApps: (e) ->
  #   @rippleTarget e, @$(e.target)
  #   @closeDropdowns()
  #   @$(e.target).find('.header__apps').toggleClass 'active'

  # showNotifications: (e) ->
  #   @rippleTarget e, @$(e.target)
  #   @closeDropdowns()
  #   @$(e.target).find('.header__notifications').toggleClass 'active'

  # showUserMenu: (e) ->
  #   @rippleTarget e, @$(e.target)
  #   @closeDropdowns()
  #   @$(e.target).closest('.icon__holder').find('.header__activity-profile-menu').toggleClass 'active'

  closeMenus: (e) ->
    @trigger 'menu:close:all'

  closeDropdowns: ->
    @$('.js-header__dropdown.active').removeClass('active')

  removeDisabledLinks: ->
    _.each @$('.menu__item-link.disabled'), (el) ->
      el.removeAttribute 'href'

  update: ->
    @removeDisabledLinks()
    @listenToTabs @show_tabs
    @ui.name.html @model.get 'name'
    @ui.login.html @model.get 'login'
    @ui.avatars.attr('src', @model.get('avatar') or '../uploads/ava.png')
