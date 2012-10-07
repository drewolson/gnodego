expect = require("chai").expect

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
                            expect(g.players["black"].messages).to.include "W+9.0"
                            expect(g.players["white"].messages).to.include "W+9.0"
                            done()

  describe "playerDisconnect", ->
    it "notifies and disconnects the opponent of the disconnected player", ->
      drew = new MockedPlayer "drew"
      william = new MockedPlayer "william"
      game = new Game
        black: drew
        white: william

      drew.disconnect()

      game.playerDisconnect()

      expect(william.disconnected).to.be.true
      expect(william.messages).to.include "\nYour opponent disconnected, you win!"

  describe "start", ->
    it "sets the board size to default", ->
      @game.start (err, response) =>
        expect(@engine.commands).to.include "boardsize 9"

    it "shows the board", ->
      @game.start (err, response) =>
        expect(@engine.commands).to.include "showboard"

    it "sets the board size based on options", ->
      game = new Game
        black: @drew
        white: @william
        engine: @engine
        boardSize: 19

      game.start (err, response) =>
        expect(@engine.commands).to.include "boardsize 19"

    it "sets a listener on the black player play event", ->
      @game.start (err, response) =>
        expect(@drew.listeners[1]).to.deep.equal ['play', @game.play]

    it "sets a listener on both players' disconnect events", ->
      @game.start (err, response) =>
        expect(@drew.listeners[0]).to.deep.equal ['disconnect', @game.playerDisconnect]
        expect(@william.listeners[0]).to.deep.equal ['disconnect', @game.playerDisconnect]

  describe "activePlayer", ->
    it "starts as black", ->
      expect(@game.activePlayer()).to.equal @drew

  describe "inactivePlayer", ->
    it "starts as white", ->
      expect(@game.inactivePlayer()).to.equal @william

  describe "listenForPlay", ->
    it "sets a listener on the new active player", ->
      @game.listenForPlay()
      expect(@drew.listeners[0]).to.deep.equal ['play', @game.play]

    it "tells the active player it is their move", ->
      @game.listenForPlay()
      expect(@drew.messages).to.include "Please select a move: "

    it "tells the inactive player to wait for their opponent", ->
      @game.listenForPlay()
      expect(@william.messages).to.include "Your opponent is selecting a move."

    it "does not tell the inactive player to wait for their opponent if so instructed", ->
      @game.listenForPlay({informOpponent: false})
      expect(@drew.messages).to.not.include "Your opponent is selecting a move."

  describe "play", ->
    it "sends a move to the engine", (done) ->
      @game.play "C6", (response) =>
        expect(@engine.commands).to.include "play black C6"
        done()

    it "lets the opponenet know that you moved", (done) ->
      @game.play "C6", (response) =>
        expect(@william.messages).to.include "Your opponent's move: C6"
        done()

    context "player passes", ->
      it "notes that the player passed", (done) ->
        @game.play "pass", (response) =>
          expect(@game.lastPlayerPassed).to.be.true
          done()

      it "lets the opponent know the player passed", (done) ->
        @game.play "pass", (response) =>
          expect(@william.messages).to.include "Your opponent's move: pass"
          done()

      it "shows the score if both players pass", (done) ->
        @game.play "pass", (response) =>
          @game.play "pass", (response) =>
            expect(@drew.messages).to.include "Waiting for final score calculation..."
            expect(@william.messages).to.include "Waiting for final score calculation..."

            expect(@engine.commands).to.include "final_score"

            expect(@drew.messages).to.include "Thanks for playing."
            expect(@william.messages).to.include "Thanks for playing."
            done()


      it "disconnects the players if both players pass", ->
        @game.play "pass", (response) =>
          @game.play "pass", (response) =>
            expect(@drew.disconnected).to.be.true
            expect(@william.disconnected).to.be.true

    context "engine accepts command",  ->
      it "toggles the active player", (done) ->
        @game.play "C6", (response) =>
          expect(@game.activePlayer()).to.equal @william
          expect(@game.inactivePlayer()).to.equal @drew
          done()

      it "shows the board", (done) ->
        @game.play "C6", (response) =>
          expect(@engine.commands).to.include "showboard"
          expect(@drew.messages).to.include "success"
          expect(@william.messages).to.include "success"
          done()

      it "resets the lastPlayerPassedState", ->
        @game.play "pass", (response) =>
          @game.play "C6", (response) =>
            expect(@game.lastPlayerPassed).to.be.false

      it "sets a listener on the new active player", ->
        @game.play "C6", (response) =>
          expect(@william.listeners[0]).to.deep.equal ['play', @game.play]

    context "engine rejects command", ->
      beforeEach ->
        @engine = new MockedFailureEngine
        @game = new Game
          black: @drew
          white: @william
          engine: @engine

      it "does not toggle the active player", (done) ->
        @game.play "C6", (response) =>
          expect(@game.activePlayer()).to.equal @drew
          expect(@game.inactivePlayer()).to.equal @william
          done()

      it "returns the error to the player", (done) ->
        @game.play "C6", (response) =>
          expect(@game.activePlayer().messages).to.include response
          done()

      it "relistens to the active player", ->
        @game.play "C6", (response) =>
          expect(@drew.listeners[0]).to.deep.equal ["play", @game.play]
