net = require "net"

Game = require "./game"
Player = require "./player"

class GameServer
  constructor: (@port) ->
    @games = []
    @unmatchedPlayers = []
    @server = net.createServer()

  findUnmatchedPlayer: (name) ->
    for player in @unmatchedPlayers
      return player if player.name is name

  onConnect: (socket) =>
    socket.once "data", (data) => @onName socket, data.toString().trim()
    socket.write "Please enter your name: "

  onName: (socket, name) ->
    player = new Player socket, name

    if @unmatchedPlayers.length > 0
      opponenet = @unmatchedPlayers.pop()
      @games.push new Game
        black: opponenet
        white: player
      socket.write "Thanks #{name}, you've been matched with #{opponenet.name}."
    else
      @unmatchedPlayers.push player
      socket.write "Thanks #{name}, we're waiting to match you with the next player."

  start: ->
    @server.on "connection", @onConnect
    @server.listen @port

module.exports = GameServer
