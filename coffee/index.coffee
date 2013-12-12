App.IndexRoute = Ember.Route.extend
    model: ->
        App.data.allGoals()

    actions:
        detail: (goal) ->
            @transitionTo 'detail', goal


App.IndexController = Ember.ArrayController.extend
    showAll: Ember.computed ->
        true

    hasGoals: Ember.computed 'length', ->
        0 < @get 'length'

    filterByInterval: (interval) ->
        _.filter @get('model'), (goal) =>
            interval is goal.get 'frequency.interval'

    filterByUnfinished: (goals) ->
        _.filter goals, (goal) =>
            complete = goal.get('hasEntryForToday') or
                goal.get('frequency.excludeWeekends') and App.get('time.isWeekend')
            not complete

    dailyGoals: Ember.computed 'model.@each', ->
        @filterByInterval 'day'

    weeklyGoals: Ember.computed 'model.@each', ->
        @filterByInterval 'week'

    monthlyGoals: Ember.computed 'model.@each', ->
        @filterByInterval 'month'

    unfinishedDailyGoals: Ember.computed 'dailyGoals.@each.hasEntryForToday', 'showAll', ->
        if @get 'showAll'
            @get 'dailyGoals'
        else
            @filterByUnfinished @get 'dailyGoals'

    unfinishedWeeklyGoals: Ember.computed 'weeklyGoals.@each.hasEntryForToday', 'showAll', ->
        if @get 'showAll'
            @get 'weeklyGoals'
        else
            @filterByUnfinished @get 'weeklyGoals'

    unfinishedMonthlyGoals: Ember.computed 'monthlyGoals.@each.hasEntryForToday', 'showAll', ->
        if @get 'showAll'
            @get 'monthlyGoals'
        else
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

    actions:
        toggleShowAll: ->
            @set 'showAll', not @get 'showAll'
