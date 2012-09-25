childProcess = require "child_process"
BufferStream = require "bufferstream"

CommandResponse = require "./command_response"
IdGenerator = require "./id_generator"

class Game
  constructor: ->
    @idGenerator = new IdGenerator
    @pendingResponses = {}

  handleResponse: (data) =>
    response = new CommandResponse data
    receiver = @pendingResponses[response.commandId()]

    if receiver?
      delete @pendingResponses[response.commandId()]
      receiver response.errorMessage(), response.data()

  performCommand: (command, cb) ->
    id = @idGenerator.next()
    @pendingResponses[id] = cb
    @gnugo.stdin.write "#{id} #{command}\n"

  start: ->
    @gnugo = childProcess.spawn "/usr/bin/env", ["gnugo", "--mode", "gtp"]
    @outputStream = new BufferStream {size: "flexible"}
    @outputStream.split "\n\n", @handleResponse
    @gnugo.stdout.pipe @outputStream

  stop: ->
    @gnugo.stdin.end()

module.exports = Game
