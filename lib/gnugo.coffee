GameServer = require "./gnugo/game_server"

server = new GameServer 8000
server.start()
