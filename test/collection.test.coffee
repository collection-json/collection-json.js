
should = require "should"
sampleJson = require "./sample.json"
sample = require "./sample.coffee"

describe "Collection+JSON", ()->
  describe "create()", ()->

    it "should generate an object with the attributes we expect", ->      
      collection = sample()
      # Collection
      should.exist collection.href
      collection.href.should.equal "/friends"
      # Links
      should.exist collection.links
      should.exist collection.links[0]
      collection.links[0].href.should.equal "/friends/rss"
      collection.link('feed').href.should.equal "/friends/rss"
      # Items
      should.exist collection.items
      should.exist collection.items[0]
      should.exist collection.items[0].data
      should.exist collection.items[0].links
      collection.items.length.should.equal 3
      collection.items[0].data.length.should.equal 2
      collection.items[0].datum("fullName").value.should.equal "J. Doe"
      collection.items[0].links.length.should.equal 2
      # Queries
      should.exist collection.queries
      should.exist collection.queries[0]
      should.exist collection.queries[0].data
      should.exist collection.queries[0].data[0]
      should.exist collection.queries[0].data[0].name
      should.exist collection.query("search")
      collection.queries.length.should.equal 1
      collection.queries[0].href.should.equal "/friends/search"
      collection.queries[0].data.length.should.equal 1
      collection.queries[0].data[0].name.should.equal "search"
      collection.query("search").prompt.should.equal "Search"
      # Template
      collection.template.data.length.should.equal 4

  describe "toJSON()", ()->

    it "should make a correct object", ->
      collection = sample()
      json = collection.toJSON()
      expected = JSON.stringify sampleJson
      JSON.stringify(json).should.equal expected

