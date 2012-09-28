assert = require "assert"
net = require "net"

helper = require "../test_helper"

describe "GameServer", ->
  describe "integration", ->
    it "asks for your name once connected then waits for a match", (done) ->
      helper.withServer (server, port) ->
        socket = new net.Socket
        socket.once "data", (data) ->
          assert.equal "Please enter your name: ", data

          socket.write "Drew"
          socket.once "data", (data) ->
            assert.equal "Thanks Drew, we're waiting to match you with the next player.", data
            done()

        socket.connect port
