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

        @set 'currentStreak.length', length
        @set 'currentStreak.start', start
        @set 'currentStreak.end', end

    calculateWeekStreak: ->

    calculateMonthStreak: ->

    findStartOfCurrentDayStreak: (entries, length=0) ->
        if not entries or entries.length is 0
            [null, 0]
        else if entries.length is 1
            [_.first(entries).date, length + 1]
        else
            [first, next] = _.first entries, 2
            console.log "Comparing first:'#{first.date}', next:'#{next.date}'"
            if moment(first.date).diff(moment(next.date), 'days') > 1
                [first.date, length + 1]
            else
                @findStartOfCurrentDayStreak _.rest(entries), length + 1
