events = require "events"

class Player extends events.EventEmitter
  constructor: (@socket) ->
    @socket.on "data", (data) =>
      @emit "play", data

  tell: (message) ->
    @socket.write "#{message}\n\n"

module.exports = Player
