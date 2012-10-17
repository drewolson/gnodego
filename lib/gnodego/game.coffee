GameEngine = require "./game_engine"

class Game
  constructor: ({black: black, white: white, engine: engine, boardSize: boardSize}) ->
    @activeColor = "black"
    @inactiveColor = "white"
    @boardSize = boardSize or 13
    @engine = engine or new GameEngine
    @lastPlayerPassed = false
    @players =
      black: black
      white: white

  activePlayer: ->
    @players[@activeColor]

  inactivePlayer: ->
    @players[@inactiveColor]

  broadcast: (message) ->
    for color, player of @players
      player.tell message

  calculateFinalScore: (cb) ->
    @broadcast "Waiting for final score calculation..."

    @engine.performCommand "final_score", (err, data) =>
      @broadcast data
      @broadcast "Thanks for playing."
      player.disconnect() for color, player of @players when not player.disconnected

      cb null, data if cb?

  listenForPlay: (options) ->
    if options?
      informOpponent = options.informOpponent
    else
      informOpponent = true

    @activePlayer().once "play", @play
    @activePlayer().prompt "Please select a move: "

    if informOpponent
      @inactivePlayer().tell "Your opponent is selecting a move."

  consecutivePasses: (position) =>
    @lastPlayerPassed && position is "pass"

  play: (position, cb) =>
    position = position.toString().trim()

    if @consecutivePasses(position)
      @calculateFinalScore(cb)
    else
      @engine.performCommands ["play #{@activeColor} #{position}", "showboard"], (err, data) =>
        if err?
          @activePlayer().tell err
          @listenForPlay
            informOpponent: false
        else
          @lastPlayerPassed = position is "pass"

          @inactivePlayer().tell "Your opponent's move: #{position}"

          @broadcast data
          @togglePlayers()
          @listenForPlay()

        cb err, data if cb?

  playerDisconnect: =>
    for color, player of @players
      if not player.disconnected
        player.tell "\nYour opponent disconnected, you win!"
        player.disconnect()

  start: (cb) ->
    player.on("disconnect", @playerDisconnect) for color, player of @players

    @broadcast "The match between #{@players["black"].name} (black) and #{@players["white"].name} (white) has begun!"
    @engine.start()
    @engine.performCommands ["boardsize #{@boardSize}", "showboard"], (err, data) =>
      @broadcast data
      @listenForPlay()
      cb null, data if cb?

  stop: ->
    @engine.stop()

  togglePlayers: ->
    @activeColor = if @activeColor is "black" then "white" else "black"
    @inactiveColor = if @inactiveColor is "black" then "white" else "black"

module.exports = Game
