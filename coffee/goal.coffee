App.GoalModel = Ember.Object.extend
    hasEntryForToday: Ember.computed 'lastCompletedOn', ->
        App.time.todaysKey() is @get 'lastCompletedOn'

    nonDayPeriodGoal: Ember.computed 'frequency.interval', ->
        'day' isnt @get 'frequency.interval'

    frequencyDescription: Ember.computed 'frequency.interval', 'frequency.daysPerPeriod', ->
        interval = @get 'frequency.interval'
        count = @get 'frequency.daysPerPeriod'
        prelude = "Meet this goal "

        if interval is 'day'
            "#{prelude} Every Day"
        else
            number = switch
                when count is 1 then "Once"
                when count is 2 then "Twice"
                else "#{count} times"

            period = switch
                when interval is 'week' then "Week"
                else "Month"

            "#{prelude} at least #{number} a #{period}"

    statusReport: Ember.computed 'frequency.interval', 'entries.@each', ->
        count = @entriesCompletedThisPeriod()
        plural = if count is 1 then "" else "s"
        period = @get 'frequency.interval'

        "This goal has been completed #{count} time#{plural} this #{period}."

    addEntry: (goalValue) ->
        entry =
            date: App.time.todaysKey()
            goalValue: goalValue

        @get('entries').unshiftObject entry
        @set 'lastCompletedOn', entry.date

        App.data.saveGoals()

    entriesCompletedThisPeriod: ->
        @entriesForThisPeriod().length

    entriesForThisPeriod: ->
        now = moment()
        intervalFunction = if 'week' is @get 'frequency.interval' then now.weeks else now.months
        currentPeriod = intervalFunction.apply now
        _.filter @entries, (entry) ->
            currentPeriod is intervalFunction.apply moment entry.date
