App.DetailRoute = Ember.Route.extend
    model: (params) ->
        App.data.getGoalById params.goal_id

    afterModel: (goal) ->
        if not goal then @transitionTo 'index'

    actions:
        delete: ->
            @transitionTo 'index'

App.DetailController = Ember.ObjectController.extend
    actions:
        delete: ->
            if confirm "Delete this goal?"
                App.data.deleteGoal @get 'model'
                true
            else
                false
