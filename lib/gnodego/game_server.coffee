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
    player = new Player socket
    player.on "disconnect", => @playerDisconnect player
    socket.once "data", (data) => @onName player, data.toString().trim()
    player.prompt "Please enter your name: "

  onName: (player, name) ->
    player.name = name

    if @unmatchedPlayers.length > 0
      opponent = @unmatchedPlayers.pop()
      game = new Game
        black: opponent
        white: player
      @games.push game
      player.tell "Thanks #{name}, you've been matched with #{opponent.name}."
      game.start()
    else
      @unmatchedPlayers.push player
      player.tell "Thanks #{name}, we're waiting to match you with the next player."

  playerDisconnect: (player) ->
    index = @unmatchedPlayers.indexOf(player)
    @unmatchedPlayers.splice(index, 1) if index > -1

  start: ->
    @server.on "connection", @onConnect
    @server.listen @port

module.exports = GameServer
