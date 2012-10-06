argv = require("optimist")
  .demand("p")
  .alias("p", "port")
  .argv

GameServer = require "./gnodego/game_server"

server = new GameServer argv.port
server.start()
