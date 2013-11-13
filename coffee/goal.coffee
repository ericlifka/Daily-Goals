App.GoalView = Ember.View.extend
    classNames: ['goal-list-entry']

App.GoalController = Ember.ObjectController.extend
    actions:
        complete: ->
            @get('model').addEntry @get 'numberInput'

    hasEntryForToday: ->
        todaysDateKey() is @get 'lastCompletedOn'
