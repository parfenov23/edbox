managerPlan = Backbone.Marionette.ItemView.extend
  template: JST['backbone_app/templates/director/setup/managers_plan_item']
  className: 'item'

  events:
    'change input' : 'changeInput'

  changeInput: (e) ->
    el = $(e.target)
    db_tasks = @model.get 'db_tasks'
    db_tasks[el.attr('name')] = el.val()
    @model.set db_tasks: db_tasks

BackboneApp.Views director: setup: managers_plan: BackboneApp.Views.director.setup.wrapper.extend
  template: JST['backbone_app/templates/director/setup/managers_plan']
  page: 'managers_plan'
  className: 'director_settings'
  itemView: managerPlan
  itemViewContainer: 'ul.plan'

  events:
    'change .main_input input' : 'changeInput'
    'change input'             : 'showButton'
    'click .toggle'            : 'innerToggle'
    'click #post'              : 'post'

  initialize: ->
    @collection = new Backbone.Collection @model.get 'users'

    @first_setup = _.compact _.map @collection.models, (u) ->
      !_.isEmpty u.get 'db_tasks'
    .length == 0

    @model.set first_setup: @first_setup

  changeInput: (e) ->
    @collection_clone = _.clone @collection
    el = $(e.target)
    _.each @collection_clone.models, (model) ->
      db_tasks = model.get 'db_tasks'
      db_tasks[el.attr('name')] = el.val()
      model.set db_tasks: db_tasks

    @collection.reset @collection_clone.toJSON()

  post: ->
    result = {}

    _.each @collection.toJSON(), (el) ->
      result[el.id] = el.db_tasks

    $.ajax
      type: 'post'
      url: '/api/directors/user_tasks_update'
      data:
        result: result
      success: (m) =>
        @ajax_success @first_setup, 'webhook'
      error: (xhr) =>
        @route_error xhr
