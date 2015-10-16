$(document).ready ->


# запуск видео в попапе
  $(document).on 'click', '.hidden__video.is__fullscrn', (e) ->
    if $(e.target)[0] != $('.js__hiddenVideo')[0]
      $('.hidden__video.is__fullscrn').removeClass('is__fullscrn')
      $('video')[0].pause()


# закрытие и остановка видео
  $(document).on 'click', '.js_openAndPlayVideoFullScreen', ->
    $('.hidden__video').addClass 'is__fullscrn'
    $('video')[0].play()


# скрытие и раскрытие списка материалов
  $(document).on 'click', '.programm__block > .adaptive__title i.ckick_shot', ->
    parentBlock = $(@).closest '.programm__block'
    if !parentBlock.hasClass('is__shot')
      parentBlock.addClass 'is__shot'
    else
      parentBlock.removeClass 'is__shot'

      
# расскрытие в блоке отзывов
  $(document).on 'click', '.js__toggle_review-list', ->
    $(@).closest('.review__section').toggleClass('is__opened')
