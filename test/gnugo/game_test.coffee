assert = require "assert"

Game = require "../../lib/gnugo/game"
Player = require "../../lib/gnugo/player"
MockedEngine = require "../support/mocked_engine"
MockedFailureEngine = require "../support/mocked_failure_engine"
MockedPlayer = require "../support/mocked_player"


describe "Game", ->
  beforeEach ->
    @engine = new MockedEngine
    @drew = new MockedPlayer "drew"
    @william = new MockedPlayer "william"
    @game = new Game
      black: @drew
      white: @william
      engine: @engine

  describe "integration", ->
    it "plays a game", ->
      game = new Game
        black: @drew
        white: @william

      game.start (err, response) ->
        game.play "C4", (err, response) ->
          game.play "C6", (err, response) ->
            assert.ok not err?

  describe "start", ->
    it "sets the board size to default", ->
      @game.start (err, response) =>
        assert.ok "boardsize 9" in @engine.commands

    it "shows the board", ->
      @game.start (err, response) =>
        assert.ok "showboard" in @engine.commands

    it "sets the board size based on options", ->
      game = new Game
        black: @drew
        white: @william
        engine: @engine
        boardSize: 19

      game.start (err, response) =>
        assert.ok "boardsize 19" in @engine.commands

    it "sets a listener on the black player play event", ->
      @game.start (err, response) =>
        assert.deepEqual ['play', @game.onPlay], @drew.listeners[0]

  describe "activePlayer", ->
    it "starts as black", ->
      assert.equal @game.activePlayer(), @drew

  describe "showBoard", ->
    it "asks the engine to show the board", (done) ->
      @game.showBoard (err, response) =>
        assert.ok "showboard" in @engine.commands
        done()

  describe "onPlay", ->
    it "calls play with the events payload", ->
      @game.onPlay "C6", (response) =>
        assert.ok "play black C6" in @engine.commands

  describe "listenForPlay", ->
    it "sets a listener on the new active player", ->
      @game.listenForPlay()
      assert.deepEqual ['play', @game.onPlay], @drew.listeners[0]

    it "tells the active player it is their move", ->
      @game.listenForPlay()
      assert.ok "Please select a move: " in @drew.messages

  describe "play", ->
    it "sends a move to the engine", (done) ->
      @game.play "C6", (response) =>
        assert.ok "play black C6" in @engine.commands
        done()

    context "engine accepts command",  ->
      it "toggles the active player", (done) ->
        @game.play "C6", (response) =>
          assert.equal @game.activePlayer(), @william
          done()

      it "shows the board", (done) ->
        @game.play "C6", (response) =>
          assert.ok "showboard" in @engine.commands
          assert.ok "success" in @drew.messages
          assert.ok "success" in @william.messages
          done()

      it "sets a listener on the new active player", ->
        @game.play "C6", (response) =>
          assert.deepEqual ['play', @game.onPlay], @william.listeners[0]

    context "engine rejects command", ->
      beforeEach ->
        @engine = new MockedFailureEngine
        @game = new Game
          black: @drew
          white: @william
          engine: @engine

      it "does not toggle the active player", (done) ->
        @game.play "C6", (response) =>
          assert.equal @game.activePlayer(), @drew
          done()

      it "returns the error to the player", (done) ->
        @game.play "C6", (response) =>
          assert.ok response in @game.activePlayer().messages
          done()

      it "relistens to the active player", ->
        @game.play "C6", (response) =>
          assert.deepEqual ["play", @game.onPlay], @drew.listeners[0]
