App.IndexRoute = Ember.Route.extend
    model: ->
        Data.allGoals()


App.IndexController = Ember.ArrayController.extend
    days: [
        'Sunday'
        'Monday'
        'Tuesday'
        'Wednesday'
        'Thursday'
        'Friday'
        'Saturday'
    ]

    months: [
        'January'
        'February'
        'March'
        'April'
        'May'
        'June'
        'July'
        'August'
        'September'
        'October'
        'November'
        'December'
    ]

    today: Ember.computed ->
        today = new Date()
        weekday = @days[today.getDay()]
        month = @months[today.getMonth()]
        day = today.getDate()

        "#{weekday} #{month} #{day}"

    isWeekend: Ember.computed ->
        dayOfWeek = @days[new Date().getDay()]
        dayOfWeek in ['Saturday', 'Sunday']

    hasGoals: Ember.computed 'length', ->
        0 < @get 'length'


    filterByInterval: (interval) ->
        _.filter @get('model'), (goal) ->
            interval is goal.get 'frequency.interval'

    filterByUnfinished: (goals) ->
        _.filter goals, (goal) ->
            complete = goal.get('hasEntryForToday') or
                goal.get('frequency.excludeWeekends') and @get('isWeekend')

            not complete

    dailyGoals: Ember.computed 'model.@each', ->
        @filterByInterval 'day'

    weeklyGoals: Ember.computed 'model.@each', ->
        @filterByInterval 'week'

    monthlyGoals: Ember.computed 'model.@each', ->
        @filterByInterval 'month'

    unfinishedDailyGoals: Ember.computed 'dailyGoals.@each.hasEntryForToday', ->
        @filterByUnfinished @get 'dailyGoals'

    unfinishedWeeklyGoals: Ember.computed 'weeklyGoals.@each.hasEntryForToday', ->
        @filterByUnfinished @get 'weeklyGoals'

    unfinishedMonthlyGoals: Ember.computed 'monthlyGoals.@each.hasEntryForToday', ->
        @filterByUnfinished @get 'monthlyGoals'

    hasDailyGoals: Ember.computed 'dailyGoals.length', ->
        0 < @get 'dailyGoals.length'

    hasWeeklyGoals: Ember.computed 'weeklyGoals.length', ->
        0 < @get 'weeklyGoals.length'

    hasMonthlyGoals: Ember.computed 'monthlyGoals.length', ->
        0 < @get 'monthlyGoals.length'

    hasUnfinishedDailyGoals: Ember.computed 'unfinishedDailyGoals.length', ->
        0 < @get 'unfinishedDailyGoals.length'

    hasUnfinishedWeeklyGoals: Ember.computed 'unfinishedWeeklyGoals.length', ->
        0 < @get 'unfinishedWeeklyGoals.length'

    hasUnfinishedMonthlyGoals: Ember.computed 'unfinishedMonthlyGoals.length', ->
        0 < @get 'unfinishedMonthlyGoals.length'
