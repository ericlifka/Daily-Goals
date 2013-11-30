App.CalendarController = Ember.ObjectController.extend()

App.CalendarView = Ember.View.extend
    didInsertElement: ->
        @renderCalendars()

    renderCalendars: ->
        today = App.time.today()
        @renderForMonth today.month(), today.year()

    renderForMonth: (month, year) ->
        {start, length} = @getMonthRange month, year
        table = @newCalendarTable()
        currentDay = 1
        while currentDay <= length
            currentDay = @addRow table, year, month, currentDay, start, length
        @$().append table

    getMonthRange: (month, year) ->
        m = moment {month, year}
        start = m.startOf('month').day()
        length = m.daysInMonth()
        {start, length}

    newCalendarTable: ->
        table = $ '<table>'
        header = $ '<tr>'
        _.each ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'], (day) ->
            header.append $('<th>').text day
        table.append header

    addRow: (table, year, month, currentDay, start, length) ->
        row = $ '<tr>'
        _.each [0..6], (day) =>
            cell = $ '<td>'
            if (day >= start or currentDay > 1) and currentDay <= length
                cell.text currentDay
                cell.addClass @getDateStatus year, month, currentDay
                currentDay += 1
            row.append cell
        table.append row
        currentDay

    getDateStatus: (year, month, currentDay) ->
        dateKey = App.time.dateKey year, month, currentDay
        model = @get 'controller.model'
        if model.hasEntryFor dateKey
            "complete"
        else
            "failed"
