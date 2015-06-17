router = Marionette.AppRouter.extend
  appRoutes:
    'signin'                  : 'signin'
    'signin/:page' : 'signin_problems'
    'signup'                  : 'signup'
    'signup/:page'            : 'signup_pages'
    'signout'                 : 'signout'
    'oferta'                  : 'oferta'

render = (v) ->
  BackboneApp.layout.main.show v

controller =
  signin: ->
    render new BackboneApp.Views.signin.index

  signin_problems: (page) ->
    render new BackboneApp.Views.signin.problems[page]

  signup: ->
    render new BackboneApp.Views.signup.index

  signup_pages: (page) ->
    render new BackboneApp.Views.signup[page]

  signout: ->
    $.removeCookie 'cham_key'
    location.href = '#signin'

  oferta: ->
    render new BackboneApp.Views.oferta.index


BackboneApp.addInitializer ->
  new router controller: controller
