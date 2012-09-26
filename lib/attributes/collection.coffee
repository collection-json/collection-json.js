
Attribute = require "../attribute"
nest = require "../nest"

module.exports = class Collection extends Attribute
  constructor: (@href)->
    super()
    @version = "1.0"

  rootNode: "collection"

nest Collection, "links", {adder: true, find: "rel"}
nest Collection, "items", {adder: true}
nest Collection, "queries", {adder: true, find: "rel", single: "query"}
nest Collection, "template", {getter: true}
nest Collection, "error", {getter: true}
