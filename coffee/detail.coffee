App.DetailRoute = Ember.Route.extend
    model: (params) ->
        Data.getGoalById params.goal_id

    afterModel: (goal) ->
        if not goal then @transitionTo 'index'

    actions:
        delete: ->
            @transitionTo 'index'

App.DetailController = Ember.ObjectController.extend
    hasLongestStreak: Ember.computed 'longestStreak.start', 'longestStreak.end', ->
        @get('longestStreak.start') and @get('longestStreak.end')

    startOfLongestStreak: Ember.computed 'frequency.interval', 'longestStreak.start', ->
        streakStartDate = moment(@get 'longestStreak.start')
        if 'month' is @get 'frequency.interval'
            streakStartDate.format 'MMMM YYYY'
        else
            streakStartDate.format 'MMMM Do YYYY'

    endOfLongestStreak: Ember.computed 'frequency.interval', 'longestStreak.end', ->
        streakEndDate = @get 'longestStreak.end'
        if streakEndDate is App.time.todaysKey()
            "through today"
        else if 'month' is @get 'frequency.interval'
            "until #{streakEndDate.format('MMMM YYYY')}"
        else
            "until #{streakEndDate.format('MMMM Do YYYY')}"

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
