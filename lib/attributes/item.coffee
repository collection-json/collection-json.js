
_ = require "underscore"

http = require "../http"

Collection = require "./collection"
Link = require "./link"
Template = require "./template"

module.exports = class Item
  constructor: (@_item, @_template)->
    @_links = {}
    @_data = null

  links: ()->
    @_item.links

  link: (rel)->
    link = _.find @_item.links||[], (link)->
      link.rel is rel
    return null if not link

    Link = require "./link"
    @_links[rel] = new Link(link) if link
    @_links[rel]

  data: ()->
    if not @_data
      @_data = {}
      for datum in @_item.data
        @_data[datum.name] = datum.value
    @_data

  datum: (name)->
    datum = _.find @_item.data||[], (datum)->
      datum.name is name
    datum?.value

  edit: ()->
    throw new Error("Item does not support editing") if not @_template
    template = _.clone @_template
    template.href = @_item.href
    new Template template, @data()

  remove: (done)->
    options = {}
    http.del @_item.href, options, (error, collection)->
      done error, new Collection collection
