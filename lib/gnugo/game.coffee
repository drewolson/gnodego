GameEngine = require "./game_engine"

class Game
  constructor: ({black: black, white: white, engine: engine, boardSize: boardSize}) ->
    @activeColor = "black"
    @boardSize = boardSize or 9
    @engine = engine or new GameEngine
    @players =
      black: black
      white: white

  activePlayer: ->
    @players[@activeColor]

  broadcast: (message) ->
    for color, player of @players
      player.tell message

  listenForPlay: ->
    @activePlayer().once "play", @onPlay

  onPlay: (move) =>
    @play move, (err, data) ->

  play: (position, cb) ->
    @engine.performCommands ["play #{@activeColor} #{position}", "showboard"], (err, data) =>
      if err?
        @activePlayer().tell err
        @listenForPlay()
        cb err, null
      else
        @activeColor = if @activeColor is "black" then "white" else "black"
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

module.exports = Game
