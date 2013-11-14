App.ManageRoute = Ember.Route.extend
    model: ->
        Data.loadGoals()

App.ManageController = Ember.ArrayController.extend
    actions:
        delete: (goal) ->


