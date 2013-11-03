App.NewController = Ember.Controller.extend
    frequencyOptions: [
        'Every Day'
        'X Days a Week'
        'X Days a Month'
    ]

    daysPerPeriodSelection: Ember.computed 'goalFrequency', ->
        selection = this.get 'goalFrequency'
        selection is 'X Days a Week' or selection is 'X Days a Month'

    periodType: Ember.computed 'goalFrequency', ->
        selection = this.get 'goalFrequency'
        if selection is 'X Days a Month' then 'month' else 'week'
