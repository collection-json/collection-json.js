
_ = require "underscore"

Collection = require "./collection"
Link = require "./link"

module.exports = class Item
  constructor: (@_item)->

  data: ()->
    @_item.data

  datum: (name)->
    datum = _.find @_item.data||[], (datum)->
      datum.name is name
    datum
