class MockedPlayer
  constructor: (@name)->
    @messages = []
    @listeners = []
    @disconnected = false

  prompt: (message) ->
    @messages.push message

  tell: (message) ->
    @messages.push message

  once: (event, cb) ->
    @listeners.push [event, cb]

  disconnect: ->
    @disconnected = true

module.exports = MockedPlayer
