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

    statusForThisPeriod: Ember.computed 'entries.@each', 'hasEntryForToday', ->
        if 'day' is @get 'frequency.interval'
            if @get 'hasEntryForToday' then 'complete' else 'uncomplete'
        else
            completed = @entriesCompletedThisPeriod()
            required = @get 'frequency.daysPerPeriod'
            remaining = required - completed
            daysRemaining = App.time.daysLeftInPeriod @get 'frequency.interval'
            if not @get 'hasEntryForToday'
                daysRemaining += 1

            switch
                when remaining <= 0 then 'complete'
                when daysRemaining is remaining then 'danger'
                when remaining > daysRemaining then 'failed'
                else 'uncomplete'

    goalCompleteForPeriod: ->
        if 'day' is @get 'frequency.interval'
            @get 'hasEntryForToday'
        else
            completed = @entriesCompletedThisPeriod()
            completed >= @get 'frequency.daysPerPeriod'

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

    hasEntryFor: (time) ->
        if moment.isMoment time
            time = time.toISOString()

        _.find @entries, (entry) ->
            entry.date is time

    monthsWithEntries: ->
        monthGroups = _.groupBy @entries, (entry) -> App.time.sortableMonthKey entry.date
        monthGroups[App.time.currentMonthkey()] = true
        _.sortBy _.keys(monthGroups), (i) -> i
