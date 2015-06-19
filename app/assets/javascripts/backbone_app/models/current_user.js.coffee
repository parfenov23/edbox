CurrentUser = Backbone.Model.extend
  url: '/api/v1/users/info'
  defaults:
    last_name: ''
    first_name: ''
    email: ''
    avatar: '../assets/ava.png'
    director: false
    name: ''

  initialize: ->
    @fetch() if $.cookie('user_key')

  isFunnelSet: ->
    @attributes.account.is_funnel_set

BackboneApp.addInitializer ->
  BackboneApp.current_user = new CurrentUser()
