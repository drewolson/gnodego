portfinder = require "portfinder"

GameServer = require "../lib/gnodego/game_server"

exports.withServer = (cb) ->
  portfinder.getPort (err, port) ->
    server = new GameServer port
    server.start()
    cb server, port
