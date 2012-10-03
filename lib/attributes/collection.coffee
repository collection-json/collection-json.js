
_ = require "underscore"
http = require "../http"

module.exports = class Collection
  constructor: (collection)->
    # Lets verify that it's a valid collection
    if not collection?.collection?.version is "1.0"
      throw new Error "Collection does not conform to Collection+JSON 1.0 Spec"

    @_collection = collection.collection
    @_links = {}
    @_items = {}
    @_template = null

  links: ()->
    @_collection.links

  link: (rel)->
    link = _.find @_collection.links||[], (link)->
      link.rel is rel
    return null if not link

    Link = require "./link"
    @_links[rel] = new Link(link) if link
    @_links[rel]

  items: ()->
    @_collection.items

  item: (index)->
    item = @_collection.items[index]
    return null if not item

    Item = require "./item"
    @_items[index] = new Item(item, @_collection.template) if item
    @_items[index]

  addItem: ()->
    throw new Error("Collection does not support adding items") if not @_collection.template
    Template = require "./template"
    template = _.clone @_collection.template
    template.href = @_collection.href
    new Template template

  queries: ()->
    @_collection.queries

  query: (rel)->
    query = _.find @_collection.queries||[], (query)->
      query.rel is rel
    return null if not query

    Query = require "./query"
    # Don't cache it since we allow you to set parameters and submit it
    new Query query

  # TODO support multiple templates:
  # https://github.com/mamund/collection-json/blob/master/extensions/templates.md
  templates: ()->
  template: (name)->
