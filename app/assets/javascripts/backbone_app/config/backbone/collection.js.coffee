# Задать параметры модели
Backbone.Collection::setOptions = Backbone.Model::setOptions = (options)->
  _.extend @, options
