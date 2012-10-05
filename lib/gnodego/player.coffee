events = require "events"

class Player extends events.EventEmitter
  constructor: (@socket) ->
    @disconnected = false
    @socket.on "data", (data) =>
      @emit "play", data

    @socket.on "close", =>
      @disconnect()
      @emit "disconnect"

  tell: (message) ->
    @prompt "#{message}\n\n"

  prompt: (message) ->
    @socket.write message

  disconnect: ->
    @disconnected = true
    @socket.destroy()

module.exports = Player
