App.GoalModel = Ember.Object.extend()

App.GoalModel.reopenClass
    loadGoals: ->
        if not @get 'initialized'
            @loadData()

        @get 'goals'

    getGoalsList: ->
        JSON.parse(localStorage.getItem 'goals') or []

    buildGoal: (goalName) ->
        description = JSON.parse(localStorage.getItem "goal.#{goalName}") or {}
        model = App.GoalModel.create description
        @set "goals.#{description.name}", model
        model

    loadData: ->
        goalNames = @getGoalsList()
        @set 'goalNames', goalNames

        @set 'goals', {}
        @buildGoal goalName for goalName in goalNames

        @set 'initialized', true

    saveGoal: (description) ->
        @addModelName description.name
        @saveModel description

    addModelName: (name) ->
        goalNames = @get 'goalNames'
        if name in goalNames
            throw "Duplicate goal: #{description.name}"

        goalNames.pushObject name
        localStorage.setItem 'goals', JSON.stringify goalNames

    saveModel: (description) ->
        model = App.GoalModel.create description
        keyPath = "goals.#{description.name}"
        @set keyPath, model
        localStorage.setItem keyPath, JSON.stringify description
        model
