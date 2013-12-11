Time = Ember.Object.extend
    todayDisplay: Ember.computed ->
        @today().format 'dddd MMMM Do'

    isWeekend: Ember.computed ->
        @today().days() in [0, 6]

    calendarMonthDisplay: (year, month) ->
        moment({year, month}).format 'MMMM YYYY'

    today: ->
        n = moment()
        moment
            years: n.year()
            months: n.month()
            days: n.date()

    date: (year, month, day) ->
        moment
            years: year
            months: month
            days: day

    todaysKey: ->
        @today().toISOString()

    dateKey: (year, month, day) ->
        @date(year, month, day).toISOString()

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

    sortableMonthKey: (dateString) ->
        date = moment dateString
        "#{date.years()}.#{@paddNumber(date.months())}"

    currentMonthkey: ->
        @sortableMonthKey @todaysKey()

    paddNumber: (number) ->
        padding = if number < 10 then "0" else ""
        "#{padding}#{number}"



App.time = Time.create()
