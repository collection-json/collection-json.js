
http = require "../http"

Collection = require "./collection"

module.exports = class Query
  constructor: (@_query, @_form={})->
  
  submit: (done=()->)->
    # TODO support URI templates
    # https://github.com/mamund/collection-json/blob/master/extensions/uri-templates.md
    options =
      qs: @_form

    http.get @_query.href, options, (error, collection)->
      done error if error
      done null, new Collection collection

  set: (key, value)->
    # Do validation here if present
    @_form[key] = value

  get: (key)->
    @_form[key]
