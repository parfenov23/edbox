Backbone.View::getInput = ->
  _.extend _.object(@$(":input[type=text][name]").map -> [[@name, $(@).val()]]),
    _.object(@$(":input[type=hidden][name]").map -> [[@name, $(@).val()]])
    _.object(@$(":input[type=password][name]").map -> [[@name, $(@).val()]])
    _.object @$("input[type=checkbox][name]").map -> [[@name, @checked]]
    _.object @$("input[type=radio]:checked[name]").map -> [[@name, @value]]
