App.DetailRoute = Ember.Route.extend
    model: (params) ->
        Data.getGoalById params.goal_id

App.DetailController = Ember.ObjectController.extend()
