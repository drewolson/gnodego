class Player
  constructor: (@socket, @name) ->

  tell: (message) ->
    @socket.write message

module.exports = Player
