App.GoalModel = Ember.Object.extend()

window.Data =
    loadGoals: ->
        @loadData()
        @goalsAsArray()

    saveGoal: (description) ->
        @loadData()
        @addModelName description.name
        @saveModel description

    getGoalsList: ->
        JSON.parse(localStorage.getItem 'goals') or []

    buildGoal: (goalName) ->
        description = JSON.parse(localStorage.getItem "goals.#{goalName}") or {}
        model = App.GoalModel.create description
        @goals[description.name] = model
        model

    loadData: ->
        if not @initialized
            @goalNames = @getGoalsList()
            @goals = {}
            @buildGoal goalName for goalName in @goalNames
            @initialized = true

    addModelName: (name) ->
        if name in @goalNames
            throw "Duplicate goal: #{name}"

        @goalNames.push name
        localStorage.setItem 'goals', JSON.stringify @goalNames

    saveModel: (description) ->
        try
            model = App.GoalModel.create description
            @goals[description.name] = model
            localStorage.setItem "goals.#{description.name}", JSON.stringify description
            true
        catch Error
            false

    goalsAsArray: ->
        _.collect @goals, (goal) -> goal
