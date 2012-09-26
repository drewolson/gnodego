GameEngine = require "../../lib/gnugo/game_engine"

class MockedEngine extends GameEngine
  constructor: ->
    @commands = []

  performCommand: (command, cb) ->
    @commands.push command
    cb null, "success"

  start: -> null

module.exports = MockedEngine
