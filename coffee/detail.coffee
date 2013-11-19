App.DetailRoute = Ember.Route.extend
    model: (params) ->
        Data.getGoalById params.goal_id

    actions:
        delete: ->
            @transitionTo 'index'

App.DetailController = Ember.ObjectController.extend
    frequencyDescription: Ember.computed 'frequency.interval', 'frequency.daysPerPeriod', ->
        interval = @get 'frequency.interval'
        count = @get 'frequency.daysPerPeriod'
        prelude = "Meet this goal "

        if interval is 'day'
            "#{prelude} Every Day"
        else
            number = if count is 1
                    "Once"
                else if count is 2
                    "Twice"
                else
                    "#{count} times"

            period = if interval is 'week'
                    "Week"
                else
                    "Month"

            "#{prelude} at least #{number} a #{period}"

    actions:
        delete: ->
            if confirm "Delete this goal?"
                Data.deleteGoal @get 'model'
                true
            else
                false
