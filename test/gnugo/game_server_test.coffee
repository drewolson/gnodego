assert = require "assert"
net = require "net"

helper = require "../test_helper"
MockedPlayer = require "../support/mocked_player"

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
          server.unmatchedPlayers.push new MockedPlayer "William"

          socket = new net.Socket
          socket.once "data", (data) ->
            assert.equal "Please enter your name: ", data.toString()

            socket.write "Drew\n"
            socket.once "data", (data) ->
              assert.ok /Thanks Drew, you've been matched with William\./.test(data.toString())
              assert.equal server.unmatchedPlayers.length, 0

              game = server.games[0]

              assert.equal game.players.white.name, "Drew"
              done()

          socket.connect port

      it "broadcasts a welcome and shows the board to matched players", (done) ->
        helper.withServer (server, port) ->
          william = new MockedPlayer "William"
          server.unmatchedPlayers.push william

          socket = new net.Socket
          socket.once "data", (data) ->
            socket.write "Drew\n"
            socket.once "data", (data) ->
              socket.once "data", (data) ->
                welcomeBroadcast = "The match between William (black) and Drew (white) has begun!"
                boardState = "
  A B C D E F G H J
9 . . . . . . . . . 9
8 . . . . . . . . . 8
7 . . + . . . + . . 7
6 . . . . . . . . . 6
5 . . . . + . . . . 5
4 . . . . . . . . . 4
3 . . + . . . + . . 3
2 . . . . . . . . . 2     WHITE (O) has captured 0 stones
1 . . . . . . . . . 1     BLACK (X) has captured 0 stones
  A B C D E F G H J"
                actualBoardState = william.messages[1].replace(/\r\n|\r|\n|\s$|^\s/gm, '')
                assert.equal welcomeBroadcast.trim(), william.messages[0]
                assert.equal boardState, actualBoardState
                done()

          socket.connect port
