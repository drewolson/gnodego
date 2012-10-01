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
      if err?
        cb err, null
      else
        rest = commands[1..-1]
        if rest.length is 0
          cb err, data
        else
          @performCommands(rest, cb)

  start: ->
    bufferStream = new BufferStream
      size: "flexible"
    bufferStream.split "\n\n", @handleResponse

    @gnugo = childProcess.spawn "/usr/bin/env", ["gnugo", "--mode", "gtp"]
    @gnugo.stdout.pipe bufferStream

  stop: ->
    @gnugo.stdin.end()

module.exports = GameEngine
