assert = require "assert"

Game = require "../../lib/gnugo/game"
MockedEngine = require "../support/mocked_engine"
MockedFailureEngine = require "../support/mocked_failure_engine"

describe Game, ->
  beforeEach ->
    @engine = new MockedEngine
    @game = new Game
      black: "drew"
      white: "william"
      engine: @engine

  describe "integration", ->
    it "plays a game", ->
      game = new Game
        black: "william"
        white: "drew"

      game.play "C4", (err, response) ->
        game.play "C6", (err, response) ->
          assert.ok not err?

  describe "activePlayer", ->
    it "starts as black", ->
      assert.equal @game.activePlayer(), "drew"

  describe "showBoard", ->
    it "asks the engine to show the board", (done) ->
      @game.showBoard (response) =>
        assert.ok "showboard" in @engine.commands
        done()

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

      it "shows the board", (done) ->
        @game.play "C6", (response) =>
          assert.ok "showboard" in @engine.commands
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

      it "returns the error to the player", (done) ->
        @game.play "C6", (response) =>
          assert.equal response, "error"
          done()
