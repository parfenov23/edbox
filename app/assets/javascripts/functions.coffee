getInputs: (parent) ->
  _.extend _.object($(parent+' input[type=text][name]').map -> [[@name, $(@).val()]]),
    _.object($(parent+' input[type=hidden][name]').map -> [[@name, $(@).val()]])
    _.object($(parent+' input[type=password][name]').map -> [[@name, $(@).val()]])
    _.object $(parent+' input[type=checkbox][name]').map -> [[@name, @checked]]
    _.object $(parent+' input[type=radio]:checked[name]').map -> [[@name, @value]]

