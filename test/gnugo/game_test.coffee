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

  describe "performCommands", ->
    it "works with a single command", (done) ->
      game = new Game
      game.start()

      game.performCommands ["protocol_version"], (err, data) ->
        assert.equal data, "2"
        done()

    it "plays a game of go", (done) ->
      game = new Game
      game.start()

      game.performCommands ["boardsize 9", "play black c3", "play white c6", "move_history"], (err, data) ->
        assert.equal data, "white C6\nblack C3"
        done()
