
http = require "./http"

module.exports = (href, options, done)->
  if typeof options is 'function'
    done = options
    options = {}

  http.get href, options, (error, collection)->
    return done error if error
    module.exports.parse collection, done

# Expose parse
module.exports.parse = (collection, done)->
  throw new Error("Callback must be passed to parse") if not done

  # Is collection defined?
  if not collection?
    return done()

  # If they gave us a string, turn it into an object
  if typeof collection is "string"
    try
      collection = JSON.parse collection
    catch e
      done e

  # Create a new Collection
  collectionObj = null
  try
    collectionObj = new module.exports.Collection collection
  catch e
    return done e

  error = null
  if _error = collectionObj.error
    error = new Error
    error.title = _error.title
    error.message = _error.message
    error.code = _error.code

  done error, collectionObj

# Expose Collection
module.exports.Collection = require "./attributes/collection"
