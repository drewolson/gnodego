assert = require "assert"
net = require "net"

helper = require "../test_helper"

describe "GameServer", ->
  describe "integration", ->
    it "asks for your name once connected", (done) ->
      helper.withServer (server, port) ->
        socket = new net.Socket
        socket.on "data", (data) ->
          assert.equal "Please enter your name: ", data
          done()

        socket.connect port
