assert = require "assert"
CommandResponse = require "../../lib/gnugo/command_response"

describe "CommandResponse", ->
  describe "isSuccess", ->
    it "checks first character for success", ->
      response = new CommandResponse "=1 3.8"
      assert.ok response.isSuccess()

    it "deals with failures", ->
      response = new CommandResponse "?1 error message"
      assert.ok not response.isSuccess()

  describe "commandId", ->
    it "returns the id of the command", ->
      response = new CommandResponse "=1 data"
      assert.equal "1", response.commandId()

  describe "data", ->
    it "displays data on the first line", ->
      response = new CommandResponse "=1 3.8"
      assert.equal "3.8", response.data()

  describe "errorMessage", ->
    it "returns the error message from the response", ->
      response = new CommandResponse "?1 error message"
      assert.equal "error message", response.errorMessage()
