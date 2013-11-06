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


    hasGoals: Ember.computed 'length', ->
        0 < @get 'length'
