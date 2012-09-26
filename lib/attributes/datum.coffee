
Attribute = require "../attribute"

module.exports = class Datum extends Attribute
  constructor: (params={})->
    super()
    @name = params.name
    @value = params.value
    @prompt = params.prompt
