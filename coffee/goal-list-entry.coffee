App.GoalListEntryView = Ember.View.extend
    classNameBindings: [':goal-list-entry', 'goalStatus']
    goalStatus: Ember.computed 'controller.statusForThisPeriod', ->
        @get 'controller.statusForThisPeriod'

App.GoalListEntryController = Ember.ObjectController.extend
    actions:
        complete: ->
            @get('model').addEntry @get('numberInput')
