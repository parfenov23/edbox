router = Marionette.AppRouter.extend
  appRoutes:
    'signin'      : 'signin'
    'signin/:page': 'signin_problems'
    'signup'      : 'signup'
    'signup/:page': 'signup_pages'
    'signout'     : 'signout'
    'oferta'      : 'oferta'

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
    $.removeCookie 'user_key'
    $.ajax
      type: 'GET'
      url: '/api/v1/sessions/signout'
      success: (m) =>
        # show_error('Успех',1000)
        console.log '111'
      error: (m) =>
        # show_error('Ошибка',1000)
        console.log '222'

    location.href = '#signin'

  oferta: ->
    render new BackboneApp.Views.oferta.index


BackboneApp.addInitializer ->
  new router controller: controller
