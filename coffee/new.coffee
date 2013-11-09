App.NewRoute = Ember.Route.extend
    actions:
        save: ->
            @transitionTo 'index'

App.NewController = Ember.Controller.extend
    frequencyOptions: [
        {label: 'Every Day', id: 'day'}
        {label: 'X Days a Week', id: 'week'}
        {label: 'X Days a Month', id: 'month'}
    ]

    inputTypeOptions: [
        {label: 'Checkbox', id: 'checkbox'}
        {label: 'Number', id: 'number'}
    ]

    daysPerPeriodSelection: Ember.computed 'goalFrequency', ->
        @get('goalFrequency') in ['week', 'month']

    clearForm: ->
        @set 'goalName', ''
        @set 'addNumberInput', false
        @set 'goalFrequency', ''
        @set 'daysPerPeriod', ''
        @set 'excludeWeekends', false

    actions:
        save: ->
            result = Data.saveGoal
                name: @get 'goalName'
                trackNumber: @get('addNumberInput') or false
                entries: []
                lastCompletedOn: null
                frequency:
                    interval: @get 'goalFrequency'
                    daysPerPeriod: @get('daysPerPeriod') or 1
                    excludeWeekends: @get('excludeWeekends') or false

            if result
                @clearForm()

            result
