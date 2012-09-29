events = require 'events'

class Player
  constructor: (@socket, @name) ->
    @emitter = new events.EventEmitter
    @socket.on "data", (data) =>
      @emitter.emit("play", data)

  tell: (message) ->
    @socket.write message

  once: (event, cb) ->
    @emitter.once(event, cb)

module.exports = Player
