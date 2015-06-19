# planned = ' - запланированные на сегодня задачи'
# not_planned = ' - нет запланированных на сегодня задач'

# taskView = Backbone.Marionette.ItemView.extend
#   template: JST['backbone_app/templates/director/analytics/director_analytics_task_view']
#   tag: 'li'

# userView = Backbone.Marionette.CompositeView.extend
#   template: JST['backbone_app/templates/director/analytics/director_analytics_user_view']
#   itemView: taskView
#   itemViewContainer: 'ul'
#   className: 'analytics__block'

  # initialize: ->
  #   @collection = new Backbone.Collection @model.get 'today_tasks'
  #   @mainCollection = _.clone @collection

  # onShow: ->
  #   @collection.reset @mainCollection.filter (model) =>
  #     model.get('company_name') &&
  #     model.get('company_name')?.toLowerCase().indexOf(@model.get('filter')?.toLowerCase() or '') != -1 ||
  #     model.get('user_name')?.toLowerCase().indexOf(@model.get('filter')?.toLowerCase()) != -1
  #   text = if _.isEmpty @collection.models then not_planned else planned
  #   @$('.title_description').html text

# emptyUserView = Backbone.Marionette.ItemView.extend
#   template: JST['backbone_app/templates/director/analytics/director_analytics_empty_user_view']

BackboneApp.Views director: analytics: index: Backbone.Marionette.CompositeView.extend
  template: JST['backbone_app/templates/director/analytics/index']
  className: 'analytics'
  # itemView: userView
  # emptyView: emptyUserView
  #itemViewContainer: '.analytics_block'

  header:
    title: 'Аналитика'
    hamburger: true

  events:
    'keyup #filter' : 'analiticsSearch'
    'click .icon__filter' : 'showList'
    'click .icon__list-item' : 'checkItem'

  initialize: ->
  #   @collectionClone = _.clone @collection


  analiticsSearch: (e) ->
    @collection.reset @collectionClone.filter (model) ->
      model.set filter: e.target.value

  checkItem: (e) ->
    @$(e.target).closest('.icon__list-item').addClass('checked').appendTo '.icon__list-checked'
    @$('.icon__list-checked').show()

  showList: (e) =>
    console.log $('.'+e.target.className+'')
    console.log $('.'+e.target.className+'').closest('.icon__filter-box').length < 0

    if $('.'+e.target.className+'').closest('.icon__filter-box').length < 0
      @$(e.target).find('.icon__filter-box').selector.toggleClass('show')
    else
      return false;

