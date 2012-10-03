
http = require "../http"

Collection = require "./collection"

module.exports = class Template
  constructor: (@_template, @_form={})->
  
  submit: (done=()->)->
    form = _.map @_form, (value, name)->
      name: name, value: value

    options =
      body:
        template:
          data: form

    http.post @_template.href, options, (error, collection)->
      done error if error
      done null, new Collection collection

  set: (key, value)->
    # Do validation here if present
    # https://github.com/mamund/collection-json/blob/master/extensions/template-validation.md
    @_form[key] = value

  get: (key)->
    @_form[key]
