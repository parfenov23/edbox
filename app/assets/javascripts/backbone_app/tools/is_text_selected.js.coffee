Backbone.View::is_text_selected = ->
    selectedText = if window.getSelection
      window.getSelection()
    else if document.getSelection
      document.getSelection()
    else if document.selection
      ie = true
      document.selection.createRange()
    if ie then selectedText.text else selectedText.toLocaleString()
