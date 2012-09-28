assert = require "assert"
net = require "net"

helper = require "../test_helper"
Player = require "../../lib/gnugo/player"

describe "GameServer", ->
  describe "onConnect", ->
    it "asks for your name once connected then waits for a match", (done) ->
      helper.withServer (server, port) ->
        socket = new net.Socket
        socket.once "data", (data) ->
          assert.equal "Please enter your name: ", data.toString()

          socket.write "Drew\n"
          socket.once "data", (data) ->
            assert.equal "Thanks Drew, we're waiting to match you with the next player.", data.toString()
            done()

        socket.connect port

    describe "unmatchedPlayers", ->
      it "adds the player to unmatched players if there is no one available for a match", (done) ->
        helper.withServer (server, port) ->
          socket = new net.Socket
          socket.once "data", (data) ->
            assert.equal "Please enter your name: ", data.toString()

            socket.write "Drew\n"
            socket.once "data", (data) ->
              player = server.findUnmatchedPlayer "Drew"
              assert.equal "Drew", player.name
              done()

          socket.connect port

      it "matches the player with any existing unmatched player", (done) ->
        helper.withServer (server, port) ->
          server.unmatchedPlayers.push new Player new net.Socket, "William"

          socket = new net.Socket
          socket.once "data", (data) ->
            assert.equal "Please enter your name: ", data.toString()

            socket.write "Drew\n"
            socket.once "data", (data) ->
              assert.equal "Thanks Drew, you've been matched with William.", data.toString()
              assert.equal server.unmatchedPlayers.length, 0

              game = server.games[0]

              assert.equal game.players.white.name, "Drew"
              done()

          socket.connect port
