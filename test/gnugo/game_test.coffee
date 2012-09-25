assert = require "assert"
Game = require "../../lib/gnugo/game"

describe Game, ->
  describe "performCommand", ->
    it "returns the result of calling a command", (done) ->
      game = new Game
      game.start()
      game.performCommand "version", (err, data) ->
        assert.equal data, "3.8"
        done()
