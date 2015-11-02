normalShift = (dir, shEl) ->
  deltaMove = 216 * 4
  currMarg = parseInt(shEl.css('marginLeft'))
  shEl.css (
    marginLeft: currMarg + deltaMove * -dir
  )
shotShift = (dir, shEl, resedue) ->
  deltaMove = 216 * resedue
  currMarg = parseInt(shEl.css('marginLeft'))
  shEl.css (
    marginLeft: currMarg + deltaMove * -dir
    )

shiftTableBody = ->
  colArr = $('.table__column')
  movedTabletsPart = $('.status__table .wrp, .course__title__list .wrp')
  factor = 4
  qtyNormalMove = Math.floor(colArr.length / factor)
  resedue = colArr.length % factor
  x = 0
  y = 0
  atRight = false
  $(document).on 'click', '.js__move__table_col.is__active', ->
    dir = $(@).data 'direction'
    x = x + dir
    switch
      when y == 0 # первый раз
        normalShift(dir, movedTabletsPart)
        $('.js__move__table_col').addClass 'is__active'
      when x == 0 #переход к первому экрану
        if atRight # мы подходим к началу, но были уже в правом конце
          shotShift(dir, movedTabletsPart, resedue)
          $(@).removeClass 'is__active'
          atRight = false
        else # мы подходим к началу, не были уже в правом конце
          normalShift(dir, movedTabletsPart)
          $('.js__move__table_col').addClass 'is__active'
        $(@).removeClass 'is__active'
      when x < qtyNormalMove # обычное движение
        if resedue == 0 && x == (qtyNormalMove - 1) #если количество кратное 4
          normalShift(dir, movedTabletsPart)
          $(@).removeClass 'is__active'
        else #если количество колонок не кратное 4
          normalShift(dir, movedTabletsPart)
          $('.js__move__table_col').addClass 'is__active'
      when x == qtyNormalMove #правый край
        if x > y #усли двигаемся дальше в крайний правый
          if atRight
            normalShift(dir, movedTabletsPart)
            $(@).removeClass 'is__active'
          else
            shotShift(dir, movedTabletsPart, resedue)
            $(@).removeClass 'is__active'
            atRight = true
        else if x < y #передумали и вернулись назад
          normalShift(dir, movedTabletsPart)
    y = x


$(document).ready ->
  
  $(document).on 'click', '.miracle__notification .delete', ->
    $(@)
      .closest '.miracle__notification'
      .fadeOut()

  shiftTableBody()
