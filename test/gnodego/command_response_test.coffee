expect = require("chai").expect
CommandResponse = require "../../lib/gnodego/command_response"

describe "CommandResponse", ->
  describe "isSuccess", ->
    it "checks first character for success", ->
      response = new CommandResponse "=1 3.8"
      expect(response.isSuccess()).to.be.true

    it "deals with failures", ->
      response = new CommandResponse "?1 error message"
      expect(response.isSuccess()).to.be.false

  describe "commandId", ->
    it "returns the id of the command", ->
      response = new CommandResponse "=1 data"
      expect(response.commandId()).to.equal "1"

  describe "data", ->
    it "displays data on the first line", ->
      response = new CommandResponse "=1 3.8"
      expect(response.data()).to.equal "3.8"

  describe "errorMessage", ->
    it "returns the error message from the response", ->
      response = new CommandResponse "?1 error message"
      expect(response.errorMessage()).to.equal "error message"
