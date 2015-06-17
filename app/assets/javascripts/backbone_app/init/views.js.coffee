# Хранение классов View

deepMerge = (dst, src)->
  return if 'object'!=typeof src
  _.each src, (v, k)->
    if 'object'==typeof v
      deepMerge dst[k]?={}, v
    else
      dst[k]=v

BackboneApp.Views = Views = (views)->
  deepMerge Views, views
  nameTemplates views

nameTemplates = (views, prefix = '')->
  _.each views, (v, k)->
    if 'object'==typeof v
      return nameTemplates v, "#{prefix}/#{k}"
    return unless isView v
    v::template.id = "#{prefix}/#{k}"
    if isView w = v::emptyView
      w::template.id = "#{prefix}/#{k}_0"
    if isView w = v::itemView
      w::template.id = "#{prefix}/#{k}_1"

isView = (v)->
  'function'==typeof v  and
  'function'==typeof(t = v::?.template) and
  null==t.id

# do (Backbone) ->
#   _sync = Backbone.sync
#   Backbone.sync = (method, entity, options = {}) ->
#     options.beforeSend = (xhr) ->
#       xhr.setRequestHeader('CHAM-KEY', $.cookie('cham_key'))

#     sync = _sync(method, entity, options)
#     if !entity._fetch and method is "read"
#       entity._fetch = sync
