assert = require "assert"
Game = require "../../lib/gnugo/game"

class MockedEngine
  constructor: ->
    @commands = []

  performCommand: (command, cb) ->
    @commands.push command
    cb null, "Success"

class MockedFailureEngine extends MockedEngine
  performCommand: (command, cb) ->
    cb "error", null

describe Game, ->
  beforeEach ->
    @engine = new MockedEngine
    @game = new Game
      black: "drew"
      white: "william"
      engine: @engine

  describe "activePlayer", ->
    it "starts as black", ->
      assert.equal @game.activePlayer(), "drew"

  describe "play", ->
    it "sends a move to the engine", (done) ->
      @game.play "C6", (response) =>
        assert.ok "play black C6" in @engine.commands
        done()

    context "engine accepts command",  ->
      it "toggles the active player", (done) ->
        @game.play "C6", (response) =>
          assert.equal @game.activePlayer(), "william"
          done()

    context "engine rejects command", ->
      beforeEach ->
        @engine = new MockedFailureEngine
        @game = new Game
          black: "drew"
          white: "william"
          engine: @engine

      it "does not toggle the active player", (done) ->
        @game.play "C6", (response) =>
          assert.equal @game.activePlayer(), "drew"
          done()
