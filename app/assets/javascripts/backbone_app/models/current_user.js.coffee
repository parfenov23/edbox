CurrentUser = Backbone.Model.extend
  url: '/api/users/current'
  defaults:
    id: ''
    login: ''
    avatar: '../assets/ava.png'
    crm_is_admin: false
    director: false
    name: ''

  initialize: ->
    @fetch() if $.cookie('cham_key')

  isFunnelSet: ->
    @attributes.account.is_funnel_set

BackboneApp.addInitializer ->
  BackboneApp.current_user = new CurrentUser()
