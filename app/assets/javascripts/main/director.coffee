$(document).ready ->
  colArr = $('.table__column')
  factor = 4
  qtyNormalMove = Math.floor(colArr.length / factor)
  resedue = colArr.length % factor
  x = 0
  y = 0
  atRight = false
  console.log 'z   '  + qtyNormalMove
  console.log 'f   '  + resedue



  $(document).on 'click', '.js__move__table_col.is__active', ->
    dir = $(@).data 'direction'

    x = x + dir
    console.log 'x  ' + x


    switch
      when y == 0
        console.log 'frst  '
        deltaMove = 214 * 4
        currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
        $('.status__table .wrp').css (
          marginLeft: currMarg + deltaMove * -dir
          )
        $('.js__move__table_col').addClass 'is__active'

      when x == 0
        if atRight
          deltaMove = 214 * resedue
          currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
          $('.status__table .wrp').css (
            marginLeft: currMarg + deltaMove * -dir
            )
          $(@).removeClass 'is__active'
          atRight = false
          console.log 'left end'
        else
          deltaMove = 214 * 4
          currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
          $('.status__table .wrp').css (
            marginLeft: currMarg + deltaMove * -dir
            )
          $('.js__move__table_col').addClass 'is__active'

        $(@).removeClass 'is__active'

      when x < qtyNormalMove

        if resedue == 0 && x == (qtyNormalMove - 1)
          deltaMove = 214 * 4
          currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
          $('.status__table .wrp').css (
            marginLeft: currMarg + deltaMove * -dir
            )
          $(@).removeClass 'is__active'
          console.log  123
        else
          console.log 'normal move'
          deltaMove = 214 * 4
          currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
          $('.status__table .wrp').css (
            marginLeft: currMarg + deltaMove * -dir
            )
          $('.js__move__table_col').addClass 'is__active'

      when x == qtyNormalMove
        if x > y
          deltaMove = 214 * resedue
          currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
          $('.status__table .wrp').css (
            marginLeft: currMarg + deltaMove * -dir
            )
          $(@).removeClass 'is__active'
          atRight = true
          console.log 'right end'

        else if x < y
          deltaMove = 214 * 4
          currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
          $('.status__table .wrp').css (
            marginLeft: currMarg + deltaMove * -dir
            )
          console.log 'rewride  last'
      else
        $(@).removeClass 'is__active'


    console.log 'y   ' + y

    y = x
    console.log 'x  total ' + x
    console.log 'y  total ' + y

    console.log '____________click_______'

    # if 0 < x < qtyNormalMove
    #
    #
    # else if  x == qtyNormalMove
    #   if x > y
    #     deltaMove = 214 * resedue
    #     currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
    #     $('.status__table .wrp').css (
    #       marginLeft: currMarg + deltaMove * -dir
    #       )
    #     $(@).removeClass 'is__active'
    #
    #     console.log 'right end'
    #
    #   else if x < y
    #     deltaMove = 214 * 4
    #     currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
    #     $('.status__table .wrp').css (
    #       marginLeft: currMarg + deltaMove * -dir
    #       )
    #     console.log 'rewride  last'
    #
    # else if x == 1
    #   console.log 'left end'
    #
    #   if x < y
    #     deltaMove = 214 * resedue
    #     currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
    #     $('.status__table .wrp').css (
    #       marginLeft: currMarg + deltaMove * -dir
    #       )
    #     $(@).removeClass 'is__active'
    #
    #   else if x < y
    #     deltaMove = 214 * 4
    #     currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
    #     $('.status__table .wrp').css (
    #       marginLeft: currMarg + deltaMove * -dir
    #       )

#
#
#
#
#
# $(document).ready ->
#   colArr = $('.table__column')
#   factor = 4
#   qtyNormalMove = (Math.floor(colArr.length / factor) - 1)
#   x = 0
#   console.log qtyNormalMove
#
#   $(document).on 'click', '.js__move__table_col.is__active', ->
#     dir = $(@).data 'direction'
#     resedue = colArr.length % factor
#
#     console.log 'before  ' + x
#
#     switch
#       when  0 < x < qtyNormalMove
#         deltaMove = 214 * 4
#         currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
#         $('.status__table .wrp').css (
#           marginLeft: currMarg + deltaMove * -dir
#           )
#         $('.js__move__table_col').addClass 'is__active'
#         x = x + dir
#         console.log ''
#
#       when x == qtyNormalMove || x == 0
#         if dir > 0
#           deltaMove = 214 * resedue
#           currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
#           $('.status__table .wrp').css (
#             marginLeft: currMarg + deltaMove * -dir
#             )
#           $(@).removeClass 'is__active'
#         else
#           deltaMove = 214 * 4
#           currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
#           $('.status__table .wrp').css (
#             marginLeft: currMarg + deltaMove * -dir
#             )
#           $('.js__move__table_col').addClass 'is__active'
#           x = x + dir
#         console.log 'End'
#
#
#     console.log 'after  ' + x
#     console.log '____________click_______'
#
#
#
#
    # if x < qtyNormalMove

    # console.log qtyNormalMove
    # console.log resedue

    #
    #
    #
    # firstVisCol = firstVisCol + 4 * (dir * -1)
    # lastVisCol = lastVisCol + 4 * (dir * -1)
    #
    # if typeof colArr[lastVisCol] == 'undefined' || typeof colArr[firstVisCol] == 'undefined'
    #   if
    #   console.log 'stop'
    #   firstVisCol = firstVisCol + 4 * dir
    #   lastVisCol = lastVisCol + 4 * dir
    #   # console.log 'last  AF  ' + lastVisCol
    #   # console.log 'frst  af  ' + firstVisCol
    # else
    #   deltaMove = 214 * 4
    #   currMarg = parseInt($('.status__table .wrp').css('marginLeft'))
    #   $('.status__table .wrp').css (
    #     marginLeft: currMarg + deltaMove * dir
    #     )
    #   console.log 'last  ' + lastVisCol
    #   console.log 'frst  ' + firstVisCol
    #
    #
    # #
    #
    #
    # $('.table__column').removeClass('test')
    # $(colArr[lastVisCol]).addClass('test')
    #
    # # console.log typeof colArr[lastVisCol]
    #
    # if typeof colArr[lastVisCol] != 'undefined'
    #   console.log lastVisCol
    #   $('.status__table .wrp').css (
    #     marginLeft: currMarg + deltaMove * dir
    #     )
