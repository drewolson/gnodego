childProcess = require "child_process"
BufferStream = require "bufferstream"

CommandResponse = require "./command_response"
IdGenerator = require "./id_generator"

class GameEngine
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

  performCommands: (commands, cb) ->
    @performCommand commands[0], (err, data) =>
      rest = commands[1..-1]
      if rest.length is 0
        cb err, data
      else
        @performCommands(rest, cb)

  start: ->
    @gnugo = childProcess.spawn "/usr/bin/env", ["gnugo", "--mode", "gtp"]
    @outputStream = new BufferStream {size: "flexible"}
    @outputStream.split "\n\n", @handleResponse
    @gnugo.stdout.pipe @outputStream

  stop: ->
    @gnugo.stdin.end()

module.exports = GameEngine
