App.NewRoute = Ember.Route.extend
    actions:
        save: ->
            @transitionTo 'index'

App.NewController = Ember.Controller.extend
    frequencyOptions: [
        'Every Day'
        'X Days a Week'
        'X Days a Month'
    ]

    daysPerPeriodSelection: Ember.computed 'goalFrequency', ->
        selection = @get 'goalFrequency'
        selection is 'X Days a Week' or selection is 'X Days a Month'

    periodType: Ember.computed 'goalFrequency', ->
        selection = @get 'goalFrequency'
        if selection is 'X Days a Month' then 'month' else 'week'

    getGoalInputs: ->
        inputs = ['checkbox']
        if @get 'addNumericInput'
            inputs.push 'integer'

        inputs

    getGoalFrequencyDescription: ->
        interval: @get 'goalFrequency'
        daysPerPeriod: @get('daysPerPeriod') or 1
        excludeWeekends: @get('excludeWeekends') or false

    actions:
        save: ->
            Data.saveGoal
                name: @get 'goalName'
                inputs: @getGoalInputs()
                frequency: @getGoalFrequencyDescription()
