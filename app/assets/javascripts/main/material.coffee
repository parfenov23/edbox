$(document).ready ->  if $('#js__toTogglescreen').length
  fsButton = document.getElementById('js__toTogglescreen')
  fsElement = document.getElementById('js__text-content')
  if window.fullScreenApi.supportsFullScreen
    console.log 'YES: Your browser supports FullScreen'
    console.log 'fullScreenSupported'
    fsButton.addEventListener 'click', (->
      window.fullScreenApi.requestFullScreen fsElement
      return
    ), true
    fsElement.addEventListener fullScreenApi.fullScreenEventName, (->
      if fullScreenApi.isFullScreen()
        console.log 'Whoa, you went fullscreen'
        $('.text__content').addClass("is__fullscrn")
      else
        console.log 'Back to normal'
        $('.text__content').removeClass("is__fullscrn")

      return
    ), true
  else
    console.log 'SORRY: Your browser does not support FullScreen'
