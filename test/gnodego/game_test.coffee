assert = require "assert"

Game = require "../../lib/gnodego/game"
Player = require "../../lib/gnodego/player"
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
    it "plays a game", (done) ->
      @timeout = 5000
      g = new Game
        black: @william
        white: @drew

      g.start (e, r) ->
        g.play "A4", (e, r) -> g.play "A5", (e, r) ->
            g.play "B4", (e, r) -> g.play "B5", (e, r) ->
                g.play "C4", (e, r) -> g.play "C5", (e, r) ->
                    g.play "D4", (e, r) -> g.play "D5", (e, r) ->
                        g.play "E4", (e, r) -> g.play "E5", (e, r) ->
                            g.play "F4", (e, r) -> g.play "F5", (e, r) ->
                                g.play "G4", (e, r) -> g.play "G5", (e, re) ->
                                    g.play "H4", (e, r) -> g.play "H5", (e, r) ->
                                        g.play "J4", (e, r) -> g.play "J5", (e, r) ->
                                            g.play "pass", (e, r) -> g.play "pass", (e, r) ->
                                                assert.ok "W+9.0" in g.players['black'].messages
                                                assert.ok "W+9.0" in g.players['white'].messages
                                                done()

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
        assert.deepEqual ['play', @game.play], @drew.listeners[0]

  describe "activePlayer", ->
    it "starts as black", ->
      assert.equal @game.activePlayer(), @drew

  describe "inactivePlayer", ->
    it "starts as white", ->
      assert.equal @game.inactivePlayer(), @william

  describe "listenForPlay", ->
    it "sets a listener on the new active player", ->
      @game.listenForPlay()
      assert.deepEqual ['play', @game.play], @drew.listeners[0]

    it "tells the active player it is their move", ->
      @game.listenForPlay()
      assert.ok "Please select a move: " in @drew.messages

    it "tells the inactive player to wait for their opponent", ->
      @game.listenForPlay()
      assert.ok "Your opponent is selecting a move." in @william.messages

    it "does not tell the inactive player to wait for their opponent if so instructed", ->
      @game.listenForPlay({informOpponent: false})
      assert.ok "Your opponent is selecting a move." not in @william.messages

  describe "play", ->
    it "sends a move to the engine", (done) ->
      @game.play "C6", (response) =>
        assert.ok "play black C6" in @engine.commands
        done()

    context "player passes", ->
      it "notes that the player passed", ->
        @game.play "pass", (response) =>
          assert.ok @game.lastPlayerPassed

      it "lets the opponent know the player passed", ->
        @game.play "pass", (response) =>
          assert.ok "Your opponent passed." in @william.messages

      it "shows the score if both players pass", ->
        @game.play "pass", (response) =>
          @game.play "pass", (response) =>
            assert.ok "Waiting for final score calculation..." in @drew.messages
            assert.ok "Waiting for final score calculation..." in @william.messages

            assert.ok "final_score" in @engine.commands

            assert.ok "Thanks for playing." in @drew.messages
            assert.ok "Thanks for playing." in @william.messages

    context "engine accepts command",  ->
      it "toggles the active player", (done) ->
        @game.play "C6", (response) =>
          assert.equal @game.activePlayer(), @william
          assert.equal @game.inactivePlayer(), @drew
          done()

      it "shows the board", (done) ->
        @game.play "C6", (response) =>
          assert.ok "showboard" in @engine.commands
          assert.ok "success" in @drew.messages
          assert.ok "success" in @william.messages
          done()

      it "resets the lastPlayerPassedState", ->
        @game.play "pass", (response) =>
          @game.play "C6", (response) =>
            assert.ok not @game.lastPlayerPassed

      it "sets a listener on the new active player", ->
        @game.play "C6", (response) =>
          assert.deepEqual ['play', @game.play], @william.listeners[0]

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
          assert.equal @game.inactivePlayer(), @william
          done()

      it "returns the error to the player", (done) ->
        @game.play "C6", (response) =>
          assert.ok response in @game.activePlayer().messages
          done()

      it "relistens to the active player", ->
        @game.play "C6", (response) =>
          assert.deepEqual ["play", @game.play], @drew.listeners[0]
