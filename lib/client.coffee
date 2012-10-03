
http = require "./http"

module.exports = (href, options, done)->
  if typeof options is 'function'
    done = options
    options = {}

  http.get href, options, (error, collection)->
    done error if error
    done null, module.exports.parse collection

# Expose parse
module.exports.parse = (collection)->
  if typeof collection is "string"
    collection = JSON.parse collection
  new module.exports.Collection collection

# Expose Collection
module.exports.Collection = require "./attributes/collection"
