assert = require "assert"
Game = require "../../lib/gnugo/game"

class MockedEngine
  constructor: ->
    @commands = []

  performCommand: (command, cb) ->
    @commands.push command
    cb null, "Success"

describe Game, ->
  before ->
    @engine = new MockedEngine
    @game = new Game
      black: "drew"
      white: "william"
      engine: @engine

  describe "activePlayer", ->
    it "starts as black", ->
      assert.equal @game.activePlayer(), "drew"

  describe "play", ->
    it "toggles the active player", (done) ->
      @game.play "C6", (response) =>
        assert.equal @game.activePlayer(), "william"
        done()

    it "sends a move to the engine", (done) ->
      @game.play "C6", (response) =>
        assert.ok "play black C6" in @engine.commands
        done()

