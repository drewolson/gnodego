class MockedPlayer
  constructor: (@name)->
    @messages = []
    @listeners = []
  tell: (message) ->
    @messages.push message
  once: (event, cb) ->
    @listeners.push [event, cb]

module.exports = MockedPlayer
