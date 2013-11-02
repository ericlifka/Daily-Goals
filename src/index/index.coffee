App.IndexRoute = Ember.Route.extend
    model: ->
        name: localStorage.getItem 'goalName'

App.IndexController = Ember.ObjectController.extend
    actions:
        save: ->
            localStorage.setItem 'goalName', this.get 'goalName'
