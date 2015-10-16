$(document).ready ->
  $(document).on 'click', '.add__leadings .visible__part', (e) ->
    parentBlock = $(@).closest '.item'
    elem = parentBlock.find '.hidden__part'
    parentBlock.addClass 'is__active'
    hideElementOutOff(elem, parentBlock , e)

# добавление ведущих в инпуте на странице контентера
  $(document).on 'keyup', '.com__input-item textarea, .com__input-item input', ->
    list = $(@).closest '.com__input-item'
      .find '.hidden-list'
    if $(@).val() == ''
      list.fadeOut 300
    else
      list.fadeIn 300
# расскрытие добавочной информации
  $(document).on 'click', '.tegs__add_block .show__more', ->
    $(@).fadeOut()
      .closest '.tegs__add_block'
      .find '.visible__viewport'
      .addClass 'is__unfold'
