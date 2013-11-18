App.GoalListEntryController = Ember.ObjectController.extend
    actions:
        complete: ->
            @get('model').addEntry @get('numberInput')
