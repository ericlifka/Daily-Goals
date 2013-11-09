App.GoalView = Ember.View.extend
    classNames: ['goal-list-entry']

App.GoalController = Ember.ObjectController.extend
    checkbox: Ember.computed ->
        @hasEntryForToday()

#    : Ember.observer 'checkbox', ->
#        debugger

    isCheckbox: Ember.computed 'input', ->
        'checkbox' is @get 'input'

    isNumber: Ember.computed 'input', ->
        'number' is @get 'input'

    checkboxChange: Ember.observer 'checkbox', ->
        debugger

    hasEntryForToday: ->
        todaysDateKey() is @get 'lastCompletedOn'
