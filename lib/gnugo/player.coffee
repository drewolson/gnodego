events = require "events"

class Player extends events.EventEmitter
  constructor: (@socket, @name) ->
    @socket.on "data", (data) =>
      @emit "play", data

  tell: (message) ->
    @socket.write message

module.exports = Player
