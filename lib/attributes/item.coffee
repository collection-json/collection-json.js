
_ = require "../underscore"
http = require "../http"
client = require "../client"

Collection = require "./collection"
Link = require "./link"
Template = require "./template"

module.exports = class Item
  constructor: (@_item, @_template)->
    @_links = {}
    @_data = null

  @define "href", get: ()-> @_item.href

  datum: (key)->
    datum = _.find @_item.data, (item)-> item.name is key
    # So they don't edit it
    _.clone datum

  get: (key)->
    @datum(key)?.value

  promptFor: (key)->
    @datum(key)?.prompt

  load: (done)->
    options = {}

    http.get @_item.href, options, (error, collection)->
      return done error if error
      client.parse collection, done
    
  links: ()->
    @_item.links

  link: (rel)->
    link = _.find @_item.links||[], (link)->
      link.rel is rel
    return null if not link

    Link = require "./link"
    @_links[rel] = new Link(link) if link
    @_links[rel]

  edit: ()->
    throw new Error("Item does not support editing") if not @_template
    template = _.clone @_template
    template.href = @_item.href
    new Template template, @data()

  remove: (done)->
    options = {}
    http.del @_item.href, options, (error, collection)->
      return done error if error
      client.parse collection, done
