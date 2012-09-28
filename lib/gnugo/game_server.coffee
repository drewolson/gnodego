net = require "net"

class GameServer
  constructor: (@port) ->
    @server = net.createServer()

  onConnect: (socket) =>
    socket.once "data", (data) => @onName socket, data
    socket.write "Please enter your name: "

  onName: (socket, name) ->
    socket.write "Thanks #{name}, we're waiting to match you with the next player."

  start: ->
    @server.on "connection", @onConnect
    @server.listen @port

module.exports = GameServer
