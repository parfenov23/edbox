BackboneApp.Views director: setup: wrapper: Backbone.Marionette.CompositeView.extend
  template: _.template ''
  header:
    title: 'Настройки'
    hamburger: true
    actions: true
    tabs:
      statuses: 'Воронка'
      managers_invite: 'Менеджеры'
      managers_plan: 'Показатели'
      webhook: 'Другие'

  showButton: ->
    btnsHeight = @$('.btn__wrapper').outerHeight()
    @$('.btn__holder').css 'height' : btnsHeight + 'px'

  innerToggle: ->
    @$('.inner__holder').sldToggle @$('.toggle').hasClass 'active'
    @$('.toggle').toggleClass 'active'
    @$('.inner__holder').toggleClass 'show'

  ajax_success: (first_setup, link) ->
    text = 'Данные обновлены'
    text += '. Вы будете перенаправлены на следующий шаг через пару секунд.' if first_setup
    @show_error text
    if first_setup
      setTimeout ->
        location.href = "/#director/setup/#{link}"
      , 3000
    else
      location.href = '/#reload'

  onClose: ->
    $(window).unbind('scroll')
