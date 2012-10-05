assert = require "assert"
net = require "net"

Player = require "../../lib/gnodego/player"

describe "Player", ->
  describe "event emission", ->
    it "emits play event on socket's data event", (done)->
      socket = new net.Socket
      player = new Player socket, "william"
      player.once "play", (message) ->
        assert.equal message, "C6"
        done()
      socket.emit "data", "C6"

  describe "disconnect", ->
    it "closes the socket", (done)->
      socket = new net.Socket
      player = new Player socket, "william"
      socket.on 'close', ->
        assert.ok true
        done()
      player.disconnect()


