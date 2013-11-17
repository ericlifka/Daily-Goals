App.GoalModel = Ember.Object.extend
    addEntry: (goalValue) ->
        entry =
            date: todaysDateKey()
            goalValue: goalValue

        @get('entries').unshiftObject entry
        @set 'lastCompletedOn', entry.date

        Data.saveGoals()

    hasEntryForToday: Ember.computed 'lastCompletedOn', ->
        todaysDateKey() is @get 'lastCompletedOn'


App.GoalView = Ember.View.extend
    classNames: ['goal-list-entry']


App.GoalController = Ember.ObjectController.extend
    actions:
        complete: -> @get('model').addEntry @get('numberInput')


