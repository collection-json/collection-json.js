
Attribute = require "../attribute"

module.exports = class Error extends Attribute
  constructor: (params={})->
    super()
    @title = params.title
    @code = params.code
    @message = params.message
