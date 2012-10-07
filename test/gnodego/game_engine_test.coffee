expect = require("chai").expect
GameEngine = require "../../lib/gnodego/game_engine"

describe "GameEngine", ->
  describe "performCommand", ->
    it "returns the result of calling a command", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommand "protocol_version", (err, data) ->
        expect(data).to.equal "2"
        done()

  describe "performCommands", ->
    it "works with a single command", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommands ["protocol_version"], (err, data) ->
        expect(data).to.equal "2"
        done()

    it "plays a game of go", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommands ["boardsize 9", "play black c3", "play white c6", "move_history"], (err, data) ->
        expect(data).to.equal "white C6\nblack C3"
        done()

    it "stops performing commands if one errors", (done) ->
      engine = new GameEngine
      engine.start()

      engine.performCommands ["boardsize 9", "play black", "showboard"], (err, data) ->
        expect(err).to.equal "invalid color or coordinate"
        done()
