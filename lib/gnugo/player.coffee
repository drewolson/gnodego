events = require "events"

class Player extends events.EventEmitter
  constructor: (@socket) ->
    @socket.on "data", (data) =>
      @emit "play", data

  tell: (message) ->
    @prompt "#{message}\n\n"

  prompt: (message) ->
    @socket.write message

module.exports = Player
