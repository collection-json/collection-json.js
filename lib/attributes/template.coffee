
Attribute = require "../attribute"
nest = require "../nest"

module.exports = class Template extends Attribute
  constructor: (params={})->
    super()

nest Template, "data", {adder: true, find: "name", single: "datum"}
