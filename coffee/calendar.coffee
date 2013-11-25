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
        @addFirstRow table, start
        @$().append table

    getMonthRange: (month, year) ->
        m = moment {month, year}
        start = m.startOf('month').day()
        length = m.daysInMonth()
        {start, length}

    newCalendarTable: ->
        table = $ '<table>'
        header = $ '<th>'
        _.each ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'], (day) ->
            cell = $ '<td>'
            cell.text day
            header.append cell
        table.append header

    addFirstRow: (table, start) ->
        row = $ '<tr>'
        currentDay = 1
        _.each [0..6], (day) ->
            cell = $ '<td>'
            if day >= start
                cell.text currentDay++
            row.append cell
        table.append row
        currentDay
