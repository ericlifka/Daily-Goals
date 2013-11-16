App.ManageRoute = Ember.Route.extend
    model: ->
        Data.allGoals()


App.ManageController = Ember.ArrayController.extend
    actions:
        delete: (goal) ->
            Data.deleteGoal goal
