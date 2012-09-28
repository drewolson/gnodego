assert = require "assert"
GameEngine = require "../../lib/gnugo/game_engine"

describe "GameEngine", ->
  describe "performCommand", ->
    it "returns the result of calling a command", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommand "protocol_version", (err, data) ->
        assert.equal data, "2"
        done()

  describe "performCommands", ->
    it "works with a single command", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommands ["protocol_version"], (err, data) ->
        assert.equal data, "2"
        done()

    it "plays a game of go", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommands ["boardsize 9", "play black c3", "play white c6", "move_history"], (err, data) ->
        assert.equal data, "white C6\nblack C3"
        done()
