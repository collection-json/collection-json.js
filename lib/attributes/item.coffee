
Attribute = require "../attribute"
nest = require "../nest"

module.exports = class Item extends Attribute
  constructor: (params={})->
    super()
    @href = params.href||throw Error "Href must be defined"

nest Item, "links", {adder: true, find: "rel"}
nest Item, "data", {adder: true, find: "name", single: "datum"}
