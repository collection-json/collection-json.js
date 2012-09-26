
Attribute = require "../attribute"

module.exports = class Link extends Attribute
  constructor: (params={})->
    super()
    @href = params.href||throw Error "Href must be defined"
    @rel = params.rel||throw Error "Rel must be defined"
    @render = params.render
    @prompt = params.prompt
