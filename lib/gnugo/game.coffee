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

  play: (position, cb) ->
    @engine.performCommands ["play #{@activeColor} #{position}", "showboard"], (err, data) =>
      if err?
        cb err
      else
        @activeColor = if @activeColor is "black" then "white" else "black"
        cb data

  showBoard: (cb) ->
    @engine.performCommand "showboard", (err, data) ->
      cb null, data

  start: (cb) ->
    @engine.start()
    @engine.performCommands ["boardsize #{@boardSize}", "showboard"], (err, data) ->
      cb null, data

  stop: ->
    @engine.stop()

module.exports = Game
