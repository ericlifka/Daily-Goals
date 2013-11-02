App.IndexRoute = Ember.Route.extend
    model: ->
        localStorage.getItem('goals') or []

App.IndexController = Ember.ArrayController.extend
    hasGoals: Ember.computed 'length', ->
        0 < this.get 'length'
