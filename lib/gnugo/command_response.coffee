class CommandResponse
  constructor: (rawResponse) ->
    @rawResponse = rawResponse.toString()

  commandId: ->
    @headers().commandId

  data: ->
    if @isSuccess()
      @rawResponse.split(" ")[1..-1].join(" ")
    else
      null

  error: ->
    if @isSuccess()
      null
    else
      words = @lines[0].split " "
      words[1..-1].join " "

  headers: ->
    headerString = @rawResponse.split(" ")[0]

    {
      successFlag: headerString[0],
      commandId: headerString[1..-1]
    }

  isSuccess: ->
    @headers().successFlag is "="

  lines: ->
    rawWithoutHeaders = @rawResponse.split(" ")[1..-1].join " ".strip
    raw.split "\n"

module.exports = CommandResponse
