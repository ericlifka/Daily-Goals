App.CalendarController = Ember.ObjectController.extend()

App.CalendarView = Ember.View.extend
    weekdayLabels: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

    didInsertElement: ->
        @renderCalendars()

    renderCalendars: ->
        @goal = @get 'controller.model'
        @startDate = moment @goal.get 'startDate'
        @today = App.time.today()
        @months = @goal.monthsWithEntries()
        console.log @startDate

        if not @months.length
            @noData()
        else
            @nextMonth()

    noData: ->
        @$().text "You don't have any entries for this goal yet"

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
            else
                @currentCell.addClass 'failed'

    currentDate: ->
        App.time.date @currentYear, @currentMonth, @currentDay

    withinGoalRange: (date) ->
        @onOrBefore(@startDate, date) and @onOrBefore(date, @today)

    onOrBefore: (testDate, boundary) ->
        testDate.isBefore(boundary, 'day') or testDate.isSame(boundary, 'day')


#    getDateStatus: (year, month, currentDay) ->
#        date = App.time.date year, month, currentDay
#        dateKey = App.time.dateKey year, month, currentDay
#        today = App.time.today()
#        model = @get 'controller.model'
#        startDate = moment(model.startDate)
#        result = ""
#        if startDate.isSame dateKey
#            result += " start"
#        if today.isSame dateKey
#            result += " today"
#        if (startDate.isBefore(date) or startDate.isSame(date)) and (date.isBefore(today) or date.isSame(today))
#            if model.hasEntryFor dateKey
#                result += " complete"
#            else
#                result += " failed"



#    renderCalendars: ->
#        today = App.time.today()
#        @renderForMonth today.month(), today.year()
#
#    renderForMonth: (month, year) ->
#        {start, length} = @getMonthRange month, year
#        table = @newCalendarTable()
#        currentDay = 1
#        while currentDay <= length
#            currentDay = @addRow table, year, month, currentDay, start, length
#        @$().append table
#
#    newCalendarTable: ->
#        table = $ '<table>'
#        header = $ '<tr>'
#        _.each ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'], (day) ->
#            header.append $('<th>').text day
#        table.append header
#
#    addRow: (table, year, month, currentDay, start, length) ->
#        row = $ '<tr>'
#        _.each [0..6], (day) =>
#            cell = $ '<td>'
#            if (day >= start or currentDay > 1) and currentDay <= length
#                cell.text currentDay
#                cell.addClass @getDateStatus year, month, currentDay
#                currentDay += 1
#            row.append cell
#        table.append row
#        currentDay
#
