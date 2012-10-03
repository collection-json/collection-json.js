
http = require "../http"

Collection = require "./collection"

module.exports = class Link
  constructor: (@_link)->

  follow: (done=()->)->
    http.get @_link.href, {}, (error, collection)->
      done error if error
      done null, new Collection collection
