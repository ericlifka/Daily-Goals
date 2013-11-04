App.GoalModel = Ember.Object.extend()

window.Data =
    loadGoals: ->
        if not @initialized
            @loadData()

        @goalsAsArray()

    getGoalsList: ->
        JSON.parse(localStorage.getItem 'goals') or []

    buildGoal: (goalName) ->
        description = JSON.parse(localStorage.getItem "goals.#{goalName}") or {}
        model = App.GoalModel.create description
        @goals[description.name] = model
        model

    loadData: ->
        @goalNames = @getGoalsList()
        @goals = {}
        @buildGoal goalName for goalName in @goalNames
        @initialized = true

    saveGoal: (description) ->
        @addModelName description.name
        @saveModel description

    addModelName: (name) ->
        if name in @goalNames
            throw "Duplicate goal: #{name}"

        @goalNames.push name
        localStorage.setItem 'goals', JSON.stringify @goalNames

    saveModel: (description) ->
        model = App.GoalModel.create description
        @goals[description.name] = model
        localStorage.setItem "goals.#{description.name}", JSON.stringify description
        model

    goalsAsArray: ->
        _.collect @goals, (goal) -> goal
