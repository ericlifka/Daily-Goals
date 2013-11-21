App.GoalModel = Ember.Object.extend
    hasEntryForToday: Ember.computed 'lastCompletedOn', ->
        App.time.todaysKey() is @get 'lastCompletedOn'

    addEntry: (goalValue) ->
        entry =
            date: App.time.todaysKey()
            goalValue: goalValue

        @get('entries').unshiftObject entry
        @set 'lastCompletedOn', entry.date

        @calculateCurrentStreak()
        Data.saveGoals()

    calculateCurrentStreak: ->
        switch @get 'frequency.interval'
            when 'day' then @calculateDayStreak()
            when 'week' then @calculateWeekStreak()
            when 'month' then @calculateMonthStreak()

        @updateLongestStreak()

    setCurrentStreak: ({length, start, end}) ->
        @set 'currentStreak.length', length
        @set 'currentStreak.start', start
        @set 'currentStreak.end', end

    updateLongestStreak: ->
        current = @get 'currentStreak.length'
        longest = @get 'longestStreak.length'
        if current > longest
            @set 'longestStreak.length', current
            @set 'longestStreak.start', @get 'currentStreak.start'
            @set 'longestStreak.end', @get 'currentStreak.end'



    calculateDayStreak: ->
        [start, length] = @findStartOfCurrentDayStreak @entries
        end = App.time.todaysKey()

        @setCurrentStreak {length, start, end}

    findStartOfCurrentDayStreak: (entries, streakLength=0) ->
        if not entries or entries.length is 0
            [null, streakLength]
        else if entries.length is 1
            [_.first(entries).date, streakLength + 1]
        else
            [first, next] = _.first entries, 2
            if moment(first.date).diff(moment(next.date), 'days') > 1
                [first.date, streakLength + 1]
            else
                @findStartOfCurrentDayStreak _.rest(entries), streakLength + 1



    calculateWeekStreak: ->
        [start, length] = @findCurrentWeekStreak()
        end = App.time.todaysKey()

        @setCurrentStreak {length, start, end}

    findCurrentWeekStreak: ->
        bucketedEntries = @bucketEntriesByWeek @entries
        weekResults = @calculateResultsByWeek bucketedEntries, @get 'frequency.daysPerPeriod'
        sortedWeekResults = _.sortBy weekResults, 'weekKey'
        @findStartOfCurrentWeekStreak sortedWeekResults

    bucketEntriesByWeek: (entries) ->
        _.groupBy entries, (entry) =>
            date = moment entry.date
            year = date.year()
            week = @pad date.week()
            "#{year}.#{week}"

    calculateResultsByWeek: (bucketedEntries, targetCount) ->
        _.map bucketedEntries, (entries, weekKey) =>
            metThisWeek = entries.length >= targetCount
            {weekKey, metThisWeek}

    findStartOfCurrentWeekStreak: (weekResults, streakLength=0) ->
        if not weekResults or weekResults.length is 0
            [null, streakLength]
        else if weekResults.length is 1
            week = _.first weekResults
            if not week.metThisWeek
                [null, streakLength]
            else
                [@startOfWeekForWeekKey(week.weekKey), streakLength + 1]
        else
            # uses last instead of first because list is sorted in ascending order, not descending
            [previousWeek, currentWeek] = _.last weekResults, 2
            if not currentWeek.metThisWeek
                [null, streakLength]
            else if not @weeksAreOneApart currentWeek, previousWeek
                [@startOfWeekForWeekKey(currentWeek.weekKey), streakLength + 1]
            else
                [streakStartResult, streakLengthResult] = @findStartOfCurrentWeekStreak _.initial(weekResults), streakLength + 1
                if not streakStartResult
                    streakStartResult = @startOfWeekForWeekKey currentWeek.weekKey
                [streakStartResult, streakLengthResult]

    startOfWeekForWeekKey: (weekKey) ->
        [year, week] = weekKey.split '.'
        moment({year}).week(week).day(0).toISOString()

    weeksAreOneApart: (currentWeek, previousWeek) ->
        [yearCurrent, weekCurrent] = currentWeek.weekKey.split '.'
        [yearPrevious, weekPrevious] = previousWeek.weekKey.split '.'
        current = moment(year: yearCurrent).weeks weekCurrent
        previous = moment(year: yearPrevious).weeks weekPrevious
        1 is current.diff previous, 'weeks'



    calculateMonthStreak: ->

    pad: (number) ->
        if number < 10 then "0#{number}" else "#{number}"
