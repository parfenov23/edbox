$(document).ready ->
  $(document).on 'focusin', '.searchMember, .showResidueUsers', ->
    $(@).closest '.form'
      .find '.qty__left'
      .addClass 'is__active'
  $(document).on 'focusout', '.searchMember, .showResidueUsers', ->
    $(@).closest '.form'
      .find '.qty__left'
      .removeClass 'is__active'
