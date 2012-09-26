GameEngine = require "./game_engine"

class Game
  constructor: ({black: black, white: white, engine: engine}) ->
    @engine = engine or new GameEngine
    @players =
      black: black
      white: white
    @activeColor = "black"

  play: (position, cb) ->
    @engine.performCommands ["play #{@activeColor} #{position}", "showboard"], (err, data) =>
      if err?
        cb err
      else
        @activeColor = if @activeColor is "black" then "white" else "black"
        cb data

  activePlayer: ->
    @players[@activeColor]

module.exports = Game
