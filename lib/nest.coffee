
_ = require "underscore"

module.exports = (klass, key, options)->
  klass._nestedAttributes = [] if not klass._nestedAttributes
  klass._nestedClasses = [] if not klass._nestedClasses

  klass._nestedAttributes.push key

  if options.adder
    single = options.single||key.slice(0, -1)
    klassName = capitalize single

    klass._nestedClasses[key] = require "./attributes/#{single}"

    klass.prototype["add#{klassName}"] = ()->
      @[key] = [] if not @[key]
      attr = new klass._nestedClasses[key] arguments[0]
      @[key].push attr
      attr

  if options.getter
    klassName = capitalize key

    klass._nestedClasses[key] = require "./attributes/#{key}"

    klass.prototype["get#{klassName}"] = ()->
      @[key] = new klass._nestedClasses[key](arguments[0]) if not @[key]
      @[key]

  if options.find
    single = options.single||key.slice(0, -1)

    klass.prototype[single] = (attr)->
      _.find @[key]||[], (obj)->
        obj[options.find] is attr

capitalize = (string)->
  string.charAt(0).toUpperCase() + string.slice(1)
