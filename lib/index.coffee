
Collection = require "./attributes/collection"
require "./attributes/datum"
require "./attributes/error"
require "./attributes/item"
require "./attributes/link"
require "./attributes/query"
require "./attributes/template"

module.exports =
  create: (href)->
    new Collection(href)

  parse: (json)->

