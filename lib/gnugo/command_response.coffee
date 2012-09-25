class CommandResponse
  constructor: (rawResponse) ->
    rawResponse = rawResponse.toString()
    @lines = rawResponse.split "\n"

  commandId: ->
    @lines[0][1]

  data: ->
    if @isSuccess()
      @lines[1..-1].join "\n"
    else
      null

  error: ->
    if @isSuccess()
      null
    else
      words = @lines[0].split " "
      words[1..-1].join " "

  isSuccess: ->
    @lines[0][0] is "="

module.exports = CommandResponse
