$.format_price = (int = 0) ->
  int += ''
  int.replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 ')