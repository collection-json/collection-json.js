
_ = require "underscore"
http = require "../http"
client = require "../client"

Collection = require "./collection"

module.exports = class Template
  constructor: (@href, @_template, @form={})->
    _template = @_template
    _form = @form

    _.each _template.data, (datum)->
      _form[datum.name] = datum.value if not _form[datum.name]?

  datum: (key)->
    datum = _.find @_template.data, (datum)-> datum.name is key
    _.clone datum

  get: (key)->
    @form[key]

  set: (key, value)->
    @form[key] = value

  promptFor: (key)->
    @datum(key)?.prompt
  
  submit: (done=()->)->
    form = _.map @form, (value, name)->
      name: name, value: value

    options =
      body:
        template:
          data: form

    http.post @href, options, (error, collection)->
      return done error if error
      client.parse collection, done
