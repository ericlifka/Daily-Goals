App.NewRoute = Ember.Route.extend
    actions:
        save: -> @transitionTo 'index'
        cancel: -> @transitionTo 'index'


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
        console.log "saving"
        Data.newGoal
            name: @get 'goalName'
            trackNumber: @get 'addNumberInput'
            interval: @get 'goalFrequency'
            daysPerPeriod: @get 'daysPerPeriod'
            excludeWeekends: @get 'excludeWeekends'

    clearForm: ->
        @set 'goalName', ''
        @set 'addNumberInput', false
        @set 'goalFrequency', ''
        @set 'daysPerPeriod', ''
        @set 'excludeWeekends', false
        true

    actions:
        save: ->
            console.log 'save controler'
            result = @saveForm()
            console.log "result: #{result}"
            if result
                @clearForm()
            result

        cancel: ->
            @clearForm()
