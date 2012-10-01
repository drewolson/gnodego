GameEngine = require "./game_engine"

class Game
  constructor: ({black: black, white: white, engine: engine, boardSize: boardSize}) ->
    @activeColor = "black"
    @inactiveColor = "white"
    @boardSize = boardSize or 9
    @engine = engine or new GameEngine
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

  listenForPlay: (options) ->
    if options?
      informOpponent = options.informOpponent
    else
      informOpponent = true

    @activePlayer().once "play", @onPlay
    @activePlayer().prompt "Please select a move: "

    if informOpponent
      @inactivePlayer().tell "Your opponent is selecting a move."

  onPlay: (move) =>
    @play move, (err, data) ->

  play: (position, cb) ->
    @engine.performCommands ["play #{@activeColor} #{position}", "showboard"], (err, data) =>
      if err?
        @activePlayer().tell err
        @listenForPlay
          informOpponent: false
        cb err, null
      else
        @togglePlayers()
        @broadcast data
        @listenForPlay()
        cb null, data

  showBoard: (cb) ->
    @engine.performCommand "showboard", (err, data) ->
      cb null, data

  start: (cb) ->
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
