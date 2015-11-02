$(document).ready ->
  $(document).on 'focusin', '.searchMember', ->
    $(@).closest '.form'
      .find '.qty__left'
      .addClass 'is__active'
  $(document).on 'focusout', '.searchMember', ->
    $(@).closest '.form'
      .find '.qty__left'
      .removeClass 'is__active'
