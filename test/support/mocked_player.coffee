class MockedPlayer
  constructor: (@name)->
    @messages = []
    @listeners = []

  prompt: (message) ->
    @messages.push message

  tell: (message) ->
    @messages.push message

  once: (event, cb) ->
    @listeners.push [event, cb]

module.exports = MockedPlayer
