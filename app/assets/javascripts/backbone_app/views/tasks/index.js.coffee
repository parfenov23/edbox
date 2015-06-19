taskView = Backbone.Marionette.Layout.extend
  template: JST['backbone_app/templates/tasks/basic_task_itm']

  regions:
    basic: '.basic-task-item'

  events:
    'click .default-state' : 'openState'

  onRender: ->
    @listenTo @basic, 'show', (view) ->
      @listenTo view, 'close:open:state', =>
        @closeActiveState()
      @listenTo view, 'chage:lead', (color) =>
        @model.set lead_status_color: color
      @listenTo view, 'close', -> @stopListening view

  closeActiveState: ->
    @$('.basic-task-item').removeClass 'opened'
    @basic.show new BackboneApp.Views.tasks.closed_task model: @model

  onShow: ->
    @basic.show new BackboneApp.Views.tasks.closed_task model: @model

  openState: ->
    return false if @is_text_selected()
    lead_id =  @model.get('lead_id')
    return @show_error 'Эта задача не привязана к сделке :(' unless lead_id
    $.ajax
      url: "/api/leads/#{lead_id}?task_types=true"
      success: (m) =>
        @$('.basic-task-item').addClass 'opened'
        @basic.show new BackboneApp.Views.tasks.opened_task model: new Backbone.Model m

taskCategory = Backbone.Marionette.CompositeView.extend
  template: JST['backbone_app/templates/tasks/task_category']
  itemView: taskView
  itemViewContainer: '.task-category'

  ui:
    catTitle: '.category-title'

  initialize: ->
    @collection = new Backbone.Collection @model.get 'tasks'

  closeActiveState: ->
    @children.call 'closeActiveState'

taskType = Backbone.Marionette.CompositeView.extend
  template: JST['backbone_app/templates/tasks/task_type']
  itemView: taskCategory
  itemViewContainer: '.task-type'

  initialize: ->
    tasks = @model.get 'tasks'

    if _.isArray tasks
      collection = [ tasks: tasks ]
    else
      collection = [
        title: 'Рекомендованные задачи'
        color:'#4A90E2'
        tasks: tasks.today
        summ: _.reduce tasks.today, (memo, el) ->
          memo + el.lead_price
        , 0
      ]

    @collection = new Backbone.Collection collection

  closeActiveState: ->
    @children.call 'closeActiveState'

BackboneApp.Views tasks: index: Backbone.Marionette.CompositeView.extend
  template: JST['backbone_app/templates/tasks/today_tasks']
  itemView: taskType
  itemViewContainer: '.content'
  header:
    title: 'Задачи'
    hamburger: true
    actions: true

  events:
    'click .content' : 'closeActiveState'

  initialize: ->
    planned_tasks =
      type: 'Запланированные на сегодня задачи'
      tasks: @model.get 'today_crm_tasks'
    recomended_tasks =
      tasks: @model.get 'recommended_tasks'
      class_name: 'grey'

    @collection = new Backbone.Collection [planned_tasks, recomended_tasks]

  closeActiveState: (e) ->
    target = $ e.target
    return if target.closest('.open-state').length != 0

    @children.call 'closeActiveState'
