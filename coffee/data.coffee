App.GoalModel = Ember.Object.extend
    addEntry: (goalValue) ->
        entry =
            date: todaysDateKey()
            goalValue: goalValue

        @get('entries').unshiftObject entry
        @set 'lastCompletedOn', entry.date

        Data.save @

window.Data =
    loadGoals: ->
        @loadData()
        @goalsAsArray()

    saveGoal: (description) ->
        @loadData()
        try
            @addModelName description.name
            @saveModel description
            true
        catch Error
            alert Error
            false

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
        if not name then throw "No name entered"
        if name in @goalNames then throw "Duplicate goal: #{name}"

        @goalNames.push name
        localStorage.setItem 'goals', JSON.stringify @goalNames

    saveModel: (description) ->
        model = App.GoalModel.create description
        @goals[description.name] = model
        localStorage.setItem "goals.#{description.name}", JSON.stringify description

    deleteGoal: (goal) ->

    goalsAsArray: ->
        _.collect @goals, (goal) -> goal
