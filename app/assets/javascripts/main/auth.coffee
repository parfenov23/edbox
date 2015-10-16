authCorpAcc =->
  $('.type__acc-item input').on 'click', ->
    if $('.type__acc-item .corp__acc input').is(':checked')
      $('.auth__wrp .js__company-name').addClass('is__active')
      $('.auth__wrp .js__company-name').removeClass('is__NOactive')
      $('.auth__wrp .js__company-name input').focus()
      $('.auth__wrp .js__company-name .floating-label').text("Название компании")
    else
      $('.auth__wrp .js__company-name').removeClass('is__active')
      $('.auth__wrp .js__company-name').addClass('is__Noactive')
      $('.auth__wrp .js__company-name input').attr("placeholder", "")



$(document).ready ->
  authCorpAcc()
