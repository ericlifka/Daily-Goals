App.GoalView = Ember.View.extend
    classNames: ['goal-list-entry']

App.GoalController = Ember.ObjectController.extend
    hasEntryForToday: ->
        todaysDateKey() is @get 'lastCompletedOn'
