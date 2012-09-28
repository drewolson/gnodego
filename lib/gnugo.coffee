Game = require "./gnugo/game"

game = new Game
  black: "william"
  white: "drew"

game.start (err, data) ->
  if err?
    console.log err
  else
    console.log data

  game.stop()
