
module.exports = defaults =
  _get: (href, options, done=()->)->
    done new Error "'GET' not implemented"

  _post: (href, options, done=()->)->
    done new Error "'POST' not implemented"

  _put: (href, options, done=()->)->
    done new Error "'PUT' not implemented"

  _del: (href, options, done=()->)->
    done new Error "'DELETE' not implemented"

  cache:
    # This is a fake cache. You should probably add a real one...
    put: (key, value, time, done=()->)->
      if typeof time is 'function'
        done = time
        time = null
      done()
    del: (key, done=()->)->
      done()
    clear: (done=()->)->
      done()
    get: (key, done=()->)->
      done()
    size: (done=()->)->
      done 0
    memsize: (done=()->)->
      done 0
    debug: ()->
      true

module.exports["content-type"] = "application/vnd.collection+json"

module.exports.get = (href, options, done)->
  defaults.cache.get href, (error, collection)->
    # Give them the cached stuff if we have it
    return done error, collection if error or collection

    options.headers ||= {}
    options.headers["accept"] = module.exports["content-type"]

    module.exports.setOptions href, options

    defaults._get href, options, (error, collection, headers)->
      return done error if error
      performCache collection, headers
      done error, collection

module.exports.post = (href, options={}, done)->

  options.headers ||= {}
  options.headers["accept"] = module.exports["content-type"]
  options.headers["content-type"] = module.exports["content-type"]

  module.exports.setOptions href, options
  
  defaults._post href, options, (error, collection, headers)->
    # Do we cache this?
    done error, collection

# Should be overridden by the client
module.exports.setOptions = (href, options)->

performCache = (collection, headers)->
  # Expires
  # expires = response.headers.expires
  # # TODO convert to time-from-now
  # # Cache-Control
  # # TODO implement
  # defaults.cache.put response.request.href, response.body, new Date(expires).getTime() if expires
