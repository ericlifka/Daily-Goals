App.GoalView = Ember.View.extend
    classNames: ['goal-list-entry']

App.GoalController = Ember.ObjectController.extend
    isCheckbox: Ember.computed 'input', ->
        'checkbox' is @get 'input'

    isNumber: Ember.computed 'input', ->
        'number' is @get 'input'
