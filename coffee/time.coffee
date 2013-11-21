Time = Ember.Object.extend
    todayDisplay: Ember.computed ->
        moment().format 'dddd MMMM Do'

    today: ->
        n = moment()
        moment
            years: n.year()
            months: n.month()
            days: n.date()

    todaysKey: ->
        @today().toISOString()

    streakLengthInDays: (start) ->
        startDate = moment start
        @today().diff startDate, 'days'


App.time = Time.create()
