Game = require "./gnugo/game"

game = new Game
game.start()

game.performCommand "showboard", (err, data) ->
  if err?
    console.log err
  else
    console.log data

  game.stop()
