MockedEngine = require "./mocked_engine"

class MockedFailureEngine extends MockedEngine
  performCommand: (command, cb) ->
    cb "error", null

module.exports = MockedFailureEngine
