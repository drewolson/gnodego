class IdGenerator
  constructor: ->
    @id = 0

  next: ->
    @id += 1

module.exports = IdGenerator
