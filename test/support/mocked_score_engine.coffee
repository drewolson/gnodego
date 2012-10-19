GameEngine = require "../../lib/gnodego/game_engine"

class MockedScoreEngine extends GameEngine
  constructor: ->
    super
    @commands = []

  performCommand: (command, cb) ->
    @commands.push command

    if command is "final_score"
      cb null, "W+13.0"
    else
      super command, cb

module.exports = MockedScoreEngine
