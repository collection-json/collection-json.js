
_ = require "underscore"
http = require "../http"
client = require "../client"

Collection = require "./collection"

module.exports = class Query
  constructor: (@_query, @form={})->
    _query = @_query
    _form = @form

    _.each _query.data, (datum)->
      _form[datum.name] = datum.value if not _form[datum.name]?

  datum: (key)->
    datum = _.find @_query.data, (datum)-> datum.name is key
    _.clone datum

  get: (key)->
    @form[key]

  set: (key, value)->
    @form[key] = value

  promptFor: (key)->
    @datum(key)?.prompt

  @define "href", get: ()-> @_query.href
  @define "rel", get: ()-> @_query.rel
  @define "prompt", get: ()-> @_query.prompt

  submit: (done=()->)->
    options =
      qs: @form

    http.get @_query.href, options, (error, collection)->
      return done error if error
      client.parse collection, done
