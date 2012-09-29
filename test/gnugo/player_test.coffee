assert = require "assert"
net = require "net"

Player = require "../../lib/gnugo/player"

describe "Player", ->
  describe "event emission", ->
    it "emits play event on socket's data event", (done)->
      socket = new net.Socket
      player = new Player socket, "william"
      player.once 'play', (message) ->
        assert.equal message, "C6"
        done()
      socket.emit "data", "C6"

