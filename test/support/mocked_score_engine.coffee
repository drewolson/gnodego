GameEngine = require "../../lib/gnodego/game_engine"

class MockedScoreEngine extends GameEngine
  performCommand: (command, cb) ->
    if command is "final_score"
      cb null, "W+13.0"
    else
      super command, cb

module.exports = MockedScoreEngine
