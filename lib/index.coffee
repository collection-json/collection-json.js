
Collection = require "./attributes/collection"

module.exports =
  create: (href)->
    new Collection(href)

  parse: (json)->

