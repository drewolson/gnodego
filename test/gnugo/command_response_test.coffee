assert = require "assert"
CommandResponse = require "../../lib/gnugo/command_response"

describe CommandResponse, ->
  describe "data", ->
    it "displays data on the first line", ->
      response = new CommandResponse "=1 3.8"
      assert.equal response.data(), "3.8"
