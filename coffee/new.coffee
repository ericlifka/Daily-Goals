App.NewRoute = Ember.Route.extend
    actions:
        save: ->
            @transitionTo 'index'

        cancel: ->
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

    saveForm: ->
        Data.saveGoal
            name: @get 'goalName'
            trackNumber: @get('addNumberInput') or false
            entries: []
            lastCompletedOn: null
            frequency:
                interval: @get 'goalFrequency'
                daysPerPeriod: @get('daysPerPeriod') or 1
                excludeWeekends: @get('excludeWeekends') or false

    clearForm: ->
        @set 'goalName', ''
        @set 'addNumberInput', false
        @set 'goalFrequency', ''
        @set 'daysPerPeriod', ''
        @set 'excludeWeekends', false
        true

    actions:
        save: ->
            if @saveForm()
                @clearForm()
            else
                false

        cancel: ->
            @clearForm()
