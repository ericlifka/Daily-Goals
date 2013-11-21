App.DetailRoute = Ember.Route.extend
    model: (params) ->
        Data.getGoalById params.goal_id

    afterModel: (goal) ->
        if not goal then @transitionTo 'index'

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
            number = switch
                when count is 1 then "Once"
                when count is 2 then "Twice"
                else "#{count} times"

            period = switch
                when interval is 'week' then "Week"
                else "Month"

            "#{prelude} at least #{number} a #{period}"

    actions:
        delete: ->
            if confirm "Delete this goal?"
                Data.deleteGoal @get 'model'
                true
            else
                false
