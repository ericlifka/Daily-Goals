padNumber = (number) ->
    if number < 10
        "0#{number}"
    else
        "#{number}"

todaysDateKey = ->
    today = new Date()
    year = padNumber today.getFullYear()
    month = padNumber today.getMonth() + 1
    day = padNumber today.getDate()

    "#{year}.#{month}.#{day}"
