assert = require "assert"
Game = require "../../lib/gnugo/game"

describe Game, ->
  describe "performCommand", ->
    it "returns the result of calling a command", (done) ->
      game = new Game
      game.start()

      game.performCommand "protocol_version", (err, data) ->
        assert.equal data, "2"
        done()

    it "plays a game of go", (done) ->
      game = new Game
      game.start()
      game.performCommand "boardsize 9", (err, data) ->
        game.performCommand "play black c3", (err, data) ->
          game.performCommand "play white c6", (err, data) ->
            game.performCommand "move_history", (err, data) ->
              assert.equal data, "white C6\nblack C3"
              done()

