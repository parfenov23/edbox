$(document).ready ->
  $(document).on 'click', '.help__wrp .item .wrp', ->
    $(@).closest('.item').find('.hidden__block').addClass('is__active')
  $(document).on 'click', '.help__wrp .item .hidden__block >.title', ->
    $(@).parent().removeClass('is__active')
