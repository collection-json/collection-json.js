

module.exports = class Template
  constructor: (@_template)->
    @_form = {}
  
  submit: ()->

  set: (key, value)->
    @_form[key] = value
