
_ = require "underscore"

module.exports = class Attribute

  constructor: ()->

  toJSON: ()->
    json = {}
    _nestedAttributes = @__proto__.constructor._nestedAttributes
    for k, v of @
      if not _.isFunction(v) and k != "rootNode"
        if _nestedAttributes and k in _nestedAttributes
          if _.isArray v
            json[k] = (item.toJSON() for item in v)
          else
            json[k] = v.toJSON()
        else
          json[k] = v

    if @rootNode
      wrapped = {}
      wrapped[@rootNode] = json
      json = wrapped
    
    json     
