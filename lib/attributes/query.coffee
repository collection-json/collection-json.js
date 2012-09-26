
Attribute = require "../attribute"
nest = require "../nest"

module.exports = class Query extends Attribute
  constructor: (params={})->
    super()
    @href = params.href||throw Error "Href must be defined"
    @rel = params.rel||throw Error "Rel must be defined"
    @prompt = params.prompt

nest Query, "data", {adder: true, find: "name", single: "datum"}
