Time = Ember.Object.extend
    todayDisplay: Ember.computed ->
        @today().format 'dddd MMMM Do'

    isWeekend: Ember.computed ->
        @today().days() in [0, 6]

    today: ->
        n = moment()
        moment
            years: n.year()
            months: n.month()
            days: n.date()

    todaysKey: ->
        @today().toISOString()

    daysLeftInPeriod: (period) ->
        switch period
            when 'day' then 0
            when 'week' then @daysLeftInWeek()
            when 'month' then @daysLeftInMonth()

    daysLeftInWeek: ->
        6 - @today().days()

    daysLeftInMonth: ->
        today = @today()
        today.daysInMonth() - today.date()


App.time = Time.create()
