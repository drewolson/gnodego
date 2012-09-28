net = require "net"

class GameServer
  constructor: (@port) ->
    @server = net.createServer()
    @sockets = []

  onConnect: (socket) =>
    socket.write "Please enter your name: "

  start: ->
    @server.on "connection", @onConnect
    @server.listen @port

module.exports = GameServer
