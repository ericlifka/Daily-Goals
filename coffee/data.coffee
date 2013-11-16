currentDataVersion = 1
defaultData = {"version": 1, "goals": []}
###
{
    version: 1,
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
    dataLoadedPromise: new $.Deferred()

    initialize: (dataObject) ->
        @goals = Ember.A()
        @goals = (@goals.pushObject(@goalFromJson(goal)) for goal in dataObject.goals)
        @dataLoadedPromise.resolve()

    allGoals: ->
        goalsPromise = new $.Deferred()
        @dataLoadedPromise.then =>
            goalsPromise.resolve @goals

        goalsPromise.promise()

    newGoal: ({name, trackNumber, interval, daysPerPeriod, excludeWeekends}) ->
        if @findGoal name
            alert 'Duplicate goal name'
            false
        else
            goal = App.GoalModel.create
                name: name
                trackNumber: trackNumber or false
                entries: []
                lastCompletedOn: null
                frequency:
                    interval: interval
                    daysPerPeriod: daysPerPeriod or 1
                    excludeWeekends: excludeWeekends or false

            @goals.pushObject goal
            @saveGoals()
            true

    findGoal: (name) ->
        _.find @goals, (goal) -> goal.name is name

    saveGoals: ->
        json = JSON.stringify
            version: currentDataVersion
            goals: @getGoalsJsonArray()
        @writeJsonToFile json

    getGoalsJsonArray: ->
        @goalToJson goal for goal in @goals

    goalFromJson: (json) ->
        App.GoalModel.create json

    goalToJson: (goal) ->
        name: goal.name
        trackNumber: goal.trackNumber
        lastCompletedOn: goal.lastCompletedOn
        entries: goal.entries
        frequency:
            interval: goal.frequency.interval
            daysPerPeriod: goal.frequency.daysPerPeriod
            excludeWeekends: goal.frequency.excludeWeekends

    readDataFromFile: ->
        fileReadFailed = (error) =>
            console.log error
            @initialize defaultData

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

        window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, (fs) ->
            fs.root.getFile("goals.json", {create: true, exclusive: false}, (fileEntry) ->
                fileEntry.createWriter((writer) ->
                    writer.write json
                    console.log 'write succeeded'
                , fileWriteFailed)
            , fileWriteFailed)
        , fileWriteFailed)


document.addEventListener "deviceready", ->
    Data.readDataFromFile()
