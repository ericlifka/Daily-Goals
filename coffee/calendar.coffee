App.CalendarController = Ember.ObjectController.extend()

App.CalendarView = Ember.View.extend
    weekdayLabels: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

    didInsertElement: ->
        @renderCalendars()

    renderCalendars: ->
        @goal = @get 'controller.model'
        @startDate = moment @goal.get 'startDate'
        @today = App.time.today()
        @goalPeriod = @goal.get 'frequency.interval'
        @months = @goal.monthsWithEntries()
        @nextMonth()

    nextMonth: ->
        currentMonth = _.last @months
        @months = _.initial @months
        if currentMonth
            @displayCurrentMonth currentMonth
            @nextMonth()

    displayCurrentMonth: (currentMonth) ->
        [@currentYear, @currentMonth] = currentMonth.split '.'
        @calculateMonthRange()
        @createMonthTable()

    calculateMonthRange: ->
        m = moment
            years: @currentYear
            months: @currentMonth

        @monthStart = m.startOf('month').day()
        @monthLength = m.daysInMonth()

    createMonthTable: ->
        @table = $ '<table>'
        @createCaption()
        @createHeader()
        @populateDays()
        @table.appendTo @$()

    createCaption: ->
        caption = $ '<caption>'
        caption.text App.time.calendarMonthDisplay @currentYear, @currentMonth
        caption.appendTo @table

    createHeader: ->
        header = $ '<tr>'
        header.append($('<th>').text(day)) for day in @weekdayLabels
        header.appendTo @table

    populateDays: ->
        @currentDay = 1
        while @currentDay <= @monthLength
            @nextRow()

    nextRow: ->
        @currentRow = $ '<tr>'
        @nextDay dayOfTheWeek for dayOfTheWeek in [0..6]
        @currentRow.appendTo @table

    nextDay: (dayOfTheWeek) ->
        @currentCell = $ '<td>'
        if @currentDayWithinMonth dayOfTheWeek
            @currentCell.text @currentDay
            @styleCurrentDay()
            @currentDay += 1

        @currentCell.appendTo @currentRow

    currentDayWithinMonth: (dayOfTheWeek) ->
        if @currentDay <= @monthLength
            @currentDay > 1 or dayOfTheWeek >= @monthStart
        else
            false

    styleCurrentDay: ->
        currentDate = @currentDate()

        if currentDate.isSame @startDate, 'day'
            @currentCell.addClass 'start'

        if currentDate.isSame @today, 'day'
            @currentCell.addClass 'today'

        if @withinGoalRange currentDate
            if @goal.hasEntryFor currentDate
                @currentCell.addClass 'complete'
            else if @goalPeriod is 'day' and @notToday currentDate
                @currentCell.addClass 'failed'

    currentDate: ->
        App.time.date @currentYear, @currentMonth, @currentDay

    withinGoalRange: (date) ->
        @onOrBefore(@startDate, date) and @onOrBefore(date, @today)

    onOrBefore: (testDate, boundary) ->
        testDate.isBefore(boundary, 'day') or testDate.isSame(boundary, 'day')

    notToday: (date) ->
        not date.isSame @today, 'day'
