###
{
    version: 1
    goals: [
        {
            name: string
            trackNumber: boolean
            lastCompletedOn: "year.month.day" or null e.g. "2012.11.06"
            frequency: {
                interval: string in set ['month', 'day', 'year']
                daysPerPeriod: integer
                excludeWeekends: boolean
            }
            entries: [
                {
                    date: "year.month.day",
                    numberValue: number (this field only exists on goals with 'trackNumber' set to true)
                }
                ...
            ]
        }
        ...
    ]
}
###

Data =
    id_counter: 1
    currentDataVersion: 1
    defaultData: {"version": 1, "goals": []}

    dataLoadedPromise: new $.Deferred()

    initialize: (dataObject) ->
        @goals = Ember.A(@goalFromJson goal for goal in dataObject.goals)

        @dataLoadedPromise.resolve()

    allGoals: ->
        promise = new $.Deferred()
        @dataLoadedPromise.then =>
            promise.resolve @goals
        promise.promise()

    getGoalById: (id) ->
        if typeof id is 'string'
            id = parseInt id

        promise = new $.Deferred()
        @dataLoadedPromise.then =>
            goal = _.find @goals, (g) -> id is g.get 'id'
            promise.resolve goal
        promise.promise()

    newGoal: ({name, trackNumber, interval, daysPerPeriod, excludeWeekends}) ->
        if @findGoalByName name
            alert 'Duplicate goal name'
            false
        else
            goal = App.GoalModel.create
                id: @newId()
                name: name
                trackNumber: trackNumber or false
                entries: []
                lastCompletedOn: null
                frequency:
                    interval: interval
                    daysPerPeriod: parseInt(daysPerPeriod) or 1
                    excludeWeekends: excludeWeekends or false

            @goals.pushObject goal
            @saveGoals()
            true

    deleteGoal: (goal) ->
        @goals.removeObject goal
        @saveGoals()

    findGoalByName: (name) ->
        _.find @goals, (goal) ->
            goal.get('name') is name

    saveGoals: ->
        json = JSON.stringify
            version: @currentDataVersion
            goals: @getGoalsJsonArray()
        @writeJsonToFile json

    getGoalsJsonArray: ->
        @goalToJson goal for goal in @goals

    goalFromJson: (json) ->
        App.GoalModel.create json,
            id: @newId()

    goalToJson: (goal) ->
        name: goal.name
        trackNumber: goal.trackNumber
        lastCompletedOn: goal.lastCompletedOn
        entries: goal.entries
        frequency:
            interval: goal.frequency.interval
            daysPerPeriod: goal.frequency.daysPerPeriod
            excludeWeekends: goal.frequency.excludeWeekends

    newId: ->
        @id_counter++

    readDataFromFile: ->
        fileReadFailed = (error) =>
            console.log error
            @initialize @defaultData

        fileReadSucceeded = (event) =>
            try
                @initialize JSON.parse event.target.result
            catch
                fileReadFailed()

        window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, (fs) ->
            fs.root.getFile("goals.json", null, (fileEntry) ->
                fileEntry.file((file) ->
                    reader = new FileReader()
                    reader.onerror = fileReadFailed
                    reader.onload = fileReadSucceeded
                    reader.readAsText file
                , fileReadFailed)
            , fileReadFailed)
        , fileReadFailed)

    writeJsonToFile: (json) ->
        fileWriteFailed = (error) =>
            alert "Error occurred while saving: " + error

        window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, (fs) ->
            fs.root.getFile("goals.json", {create: true, exclusive: false}, (fileEntry) ->
                fileEntry.createWriter((writer) ->
                    writer.write json
                    console.log 'write succeeded'
                , fileWriteFailed)
            , fileWriteFailed)
        , fileWriteFailed)

    readInFakeData: ->
        @initialize
            version: 1
            goals: [
                {
                    name: "something"
                    trackNumber: true
                    lastCompletedOn: null
                    frequency: {
                        interval: 'day'
                        daysPerPeriod: 1
                        excludeWeekends: false
                    }
                    entries: []
                }
            ]

if navigator.userAgent.match /(iPhone|iPod|iPad|Android|BlackBerry)/
    document.addEventListener "deviceready", ->
        Data.readDataFromFile()
else
    jQuery ->
        Data.readInFakeData()
        Data.writeJsonToFile = ( -> )

#        console.log ".NOT_FOUND_ERR ", FileError.NOT_FOUND_ERR
#        console.log ".SECURITY_ERR ", FileError.SECURITY_ERR
#        console.log ".ABORT_ERR ", FileError.ABORT_ERR
#        console.log ".NOT_READABLE_ERR ", FileError.NOT_READABLE_ERR
#        console.log ".ENCODING_ERR ", FileError.ENCODING_ERR
#        console.log ".NO_MODIFICATION_ALLOWED_ERR ", FileError.NO_MODIFICATION_ALLOWED_ERR
#        console.log ".INVALID_STATE_ERR ", FileError.INVALID_STATE_ERR
#        console.log ".SYNTAX_ERR ", FileError.SYNTAX_ERR
#        console.log ".INVALID_MODIFICATION_ERR ", FileError.INVALID_MODIFICATION_ERR
#        console.log ".QUOTA_EXCEEDED_ERR ", FileError.QUOTA_EXCEEDED_ERR
#        console.log ".TYPE_MISMATCH_ERR ", FileError.TYPE_MISMATCH_ERR
#        console.log ".PATH_EXISTS_ERR ", FileError.PATH_EXISTS_ERR
