App.ApplicationController = Ember.Controller.extend
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
        weekday = this.days[today.getDay()]
        month = this.months[today.getMonth()]
        day = today.getDate()
        "#{weekday} #{month} #{day}"
