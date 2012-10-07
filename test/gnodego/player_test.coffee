expect = require("chai").expect
net = require "net"

Player = require "../../lib/gnodego/player"

describe "Player", ->
  describe "event emission", ->
    it "emits play event on socket's data event", (done) ->
      socket = new net.Socket
      player = new Player socket, "william"
      player.once "play", (message) ->
        expect(message).to.equal "C6"
        done()
      socket.emit "data", "C6"

    it "emits disconnect event on socket's end event", (done) ->
      socket = new net.Socket
      player = new Player socket, "william"
      player.once "disconnect", ->
        expect(player.disconnected).to.be.true
        done()

      socket.emit "close"

  describe "disconnect", ->
    it "closes the socket", (done) ->
      socket = new net.Socket
      player = new Player socket, "william"
      socket.on 'close', ->
        expect(true).to.be.true
        done()

      player.disconnect()

    it "marks the player as disconnected", ->
      socket = new net.Socket
      player = new Player socket, "william"
      player.disconnect()

      expect(player.disconnected).to.be.true
