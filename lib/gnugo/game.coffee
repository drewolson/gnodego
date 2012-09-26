GameEngine = require "./game_engine"

class Game
  constructor: ({black: black, white: white, engine: engine}) ->
    @engine = engine or new GameEngine
    @players =
      black: black
      white: white
    @activeColor = "black"

  play: (position, cb) ->
    @engine.performCommand "play #{@activeColor} #{position}", (err, data) =>
      if not err?
        @activeColor = if @activeColor is "black" then "white" else "black"
      cb data

  activePlayer: ->
    @players[@activeColor]

module.exports = Game
