class CommandResponse
  constructor: (rawResponse) ->
    @rawResponse = rawResponse.toString()
    @body = @rawResponse.split(" ")[1..-1].join(" ")

  commandId: ->
    @headers().commandId

  data: ->
    if @isSuccess() then @body else null

  errorMessage: ->
    if @isSuccess() then null else @body

  headers: ->
    headerString = @rawResponse.split(" ")[0]

    {
      successFlag: headerString[0],
      commandId: headerString[1..-1]
    }

  isSuccess: ->
    @headers().successFlag is "="

module.exports = CommandResponse
