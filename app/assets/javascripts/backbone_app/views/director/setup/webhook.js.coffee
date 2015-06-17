BackboneApp.Views director: setup: webhook: BackboneApp.Views.director.setup.wrapper.extend
  template: JST['backbone_app/templates/director/setup/webhook']
  page: 'webhook'
  className: 'director_settings'

  events:
    'click #copy__link' : 'copyLink'
    'click .toggle'     : 'innerToggle'

  onShow: ->
    @client = new ZeroClipboard(document.getElementById('copy__link'))

  copyLink: ->
    @client.on 'ready',(event) =>
      @client.on 'copy',(event) =>
        @show_error 'Ссылка скопирована' , 3000
