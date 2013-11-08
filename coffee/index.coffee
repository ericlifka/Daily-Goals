App.IndexRoute = Ember.Route.extend
    model: ->
        Data.loadGoals()

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

    filterBy: (filter) ->
        goal for goal in @get('model') when goal.frequency.interval is filter and @checkWeekend goal

    checkWeekend: (goal) ->
        not goal.frequency.excludeWeekends or not @get 'isWeekend'

    todaysGoals: Ember.computed 'model.@each', ->
        @filterBy 'day'

    hasDailyGoals: Ember.computed 'todaysGoals.length', ->
        @get 'todaysGoals.length'

    thisWeeksGoals: Ember.computed 'model.@each', ->
        @filterBy 'week'

    hasWeeklyGoals: Ember.computed 'thisWeeksGoals.length', ->
        @get 'thisWeeksGoals.length'

    thisMonthsGoals: Ember.computed 'model.@each', ->
        @filterBy 'month'

    hasMonthlyGoals: Ember.computed 'thisMonthsGoals.length', ->
        @get 'thisMonthsGoals.length'
