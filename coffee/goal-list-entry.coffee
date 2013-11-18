App.GoalListEntryView = Ember.View.extend
    classNames: ['goal-list-entry']


App.GoalListEntryController = Ember.ObjectController.extend
    actions:
        complete: -> @get('model').addEntry @get('numberInput')
