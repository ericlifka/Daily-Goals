todaysDateKey = ->
    today = new Date()
    year = today.getFullYear()
    month = today.getMonth() + 1
    day = today.getDate()

    "#{year}.#{month}.#{day}"

