BackboneApp.Views system: help: Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/system/help']

  events:
    # 'click .open_form_btn' : 'showEbaniiForm'
    # 'click .block_animate' : 'block_animate'
    # 'click .block_submit'  : 'submit'

    'click .help__button .button' : 'clickButton'

  clickButton: (e) ->
    @rippleTarget e, @$('.help__button .button')
    $(e.target).closest('.button').toggleClass('open')
    $('.help__form').toggleClass('open')

  initialize: ->
    @model = BackboneApp.current_user




  # modelEvents:
  #   'change' : 'render'

  # onShow: ->
  #   @all_valid_inputs()

  # block_animate: (e) ->
  #   target = $ e.target
  #   if target.find('.ink').length == 0
  #     target.prepend "<span class='ink'></span>"

  #   ink = target.find '.ink'
  #   ink.removeClass 'animate'

  #   unless ink.height() || ink.width()
  #     d = Math.max target.outerWidth(), target.outerHeight()
  #     ink.css height: d, width: d

  #   x = e.pageX - target.offset().left - ink.width() / 2
  #   y = e.pageY - target.offset().top - ink.height() / 2

  #   ink.css({top: y + 'px', left: x + 'px'}).addClass 'animate'

  # showEbaniiForm: (e) ->
  #   form = @$(".form_feed_back")
  #   form_height = form.height()
  #   window_size = $(window).height()
  #   btn = $ e.target
  #   parent_bloc_btn = btn.closest '.open_form_btn'
  #   if btn.hasClass 'open'
  #     parent_bloc_btn.addClass 'click'
  #     setTimeout ->
  #       parent_bloc_btn.addClass 'cross'
  #     # , 300
  #     setTimeout ->
  #       parent_bloc_btn.removeClass 'cross click'
  #       btn.removeClass('open').addClass 'close'
  #     # , 500
  #     form.css('bottom', (window_size * (- 1)) + 'px')
  #     form.show()
  #     form.animate
  #       bottom: 50
  #     , 800
  #   else
  #     parent_bloc_btn.addClass 'click'
  #     setTimeout ->
  #       parent_bloc_btn.addClass 'question'
  #     , 300
  #     setTimeout ->
  #       parent_bloc_btn.removeClass 'question click'
  #       btn.addClass('open').removeClass 'close'
  #     , 500

  #     form.animate
  #       bottom: (window_size * (- 1))
  #     , 800, -> form.hide()

  # all_valid_inputs: ->
  #   ipnuts = @$('.feedback form input, .feedback form textarea')
  #   count_valid_input = 0

  #   _.each ipnuts, (tag, i) =>
  #     count_valid_input += 1 if @valid_input(tag)

  #   if ipnuts.length == count_valid_input
  #     @$(".feedback form .submit_btn").removeClass 'disabled'
  #   else
  #     @$(".feedback form .submit_btn").addClass 'disabled'

  # valid_input: (e) ->
  #   result = false
  #   if $(e).val().length > 0
  #     result = true
  #     if $(e).attr("name") == "email"
  #       pattern = /^([a-z0-9_\.-])+@[a-z0-9-]+\.([a-z]{2,4}\.)?[a-z]{2,4}$/i
  #       if pattern.test($(e).val())
  #         result = true
  #       else
  #         result = false
  #   else
  #     result = false

  #   result

  # animate_completed: (e) ->
  #   btn = $(e)
  #   parent_block = btn.closest '.action'
  #   form = parent_block.find 'form'
  #   form.animate
  #     left: parent_block.width()
  #   , 1000, ->
  #     form.hide()

  # submit: (e) ->
  #   e.preventDefault()
  #   console.log @getInput()
