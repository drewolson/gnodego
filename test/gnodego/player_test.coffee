assert = require "assert"
net = require "net"

Player = require "../../lib/gnodego/player"

describe "Player", ->
  describe "event emission", ->
    it "emits play event on socket's data event", (done) ->
      socket = new net.Socket
      player = new Player socket, "william"
      player.once "play", (message) ->
        assert.equal message, "C6"
        done()
      socket.emit "data", "C6"

    it "emits disconnect event on socket's end event", (done) ->
      socket = new net.Socket
      player = new Player socket, "william"
      player.once "disconnect", ->
        assert.ok player.disconnected
        done()

      socket.emit "close"

  describe "disconnect", ->
    it "closes the socket", (done) ->
      socket = new net.Socket
      player = new Player socket, "william"
      socket.on 'close', ->
        assert.ok true
        done()

      player.disconnect()

    it "marks the player as disconnected", ->
      socket = new net.Socket
      player = new Player socket, "william"
      player.disconnect()

      assert.ok player.disconnected
