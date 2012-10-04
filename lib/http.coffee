
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
    done error, collection if error or collection

    options.headers ||= {}
    options["accept"] = module.exports["content-type"]

    module.exports.setOptions href, options

    defaults._get href, options, (error, response)->
      done error if error
      performCache response
      done error, JSON.parse response.body

module.exports.post = (href, options, done)->
  module.exports.setOptions href, options
  
  defaults._post href, options, (error, response)->
    # Do we cache this?
    done error, JSON.parse response.body

# Should be overridden by the client
module.exports.setOptions = (href, options)->

performCache = (response)->
  # Expires
  expires = response.headers.expires
  # TODO convert to time-from-now
  # Cache-Control
  # TODO implement
  defaults.cache.put response.request.href, response.body, new Date(expires).getTime() if expires
