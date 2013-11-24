App.GoalModel = Ember.Object.extend
    hasEntryForToday: Ember.computed 'lastCompletedOn', ->
        App.time.todaysKey() is @get 'lastCompletedOn'

    addEntry: (goalValue) ->
        entry =
            date: App.time.todaysKey()
            goalValue: goalValue

        @get('entries').unshiftObject entry
        @set 'lastCompletedOn', entry.date

        App.data.saveGoals()
