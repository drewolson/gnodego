class MockedPlayer
  constructor: (@name)->
    @messages = []
  tell: (message) ->
    @messages.push message

module.exports = MockedPlayer
