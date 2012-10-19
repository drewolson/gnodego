MockedEngine = require "./mocked_engine"

class MockedScoreEngine extends MockedEngine
  performCommand: (command, cb) ->
    @commands.push command

    if command is "final_score"
      cb null, "W+13.0"
    else
      cb null, "success"

module.exports = MockedScoreEngine
