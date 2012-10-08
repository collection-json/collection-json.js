
should = require "should"

cj = require "../.."

describe "Integration", ->

  app = require "./collection/app"
  db = require "./collection/fixtures/db"

  root = app.site
  server = null

  before (done)->
    server = app.listen 3000, ()->
      done()

  after (done)->
    server.close ()-> done()

  rootCollection = undefined

  beforeEach (done)->
    # db.reset()
    cj root, (error, collection)->
      throw error if error
      should.exist collection, "No root collection was returned"
      rootCollection = collection
      done()

  it "should have an href", ->
    rootCollection.href.should.equal root

  it "should have links", ->
    should.exist rootCollection.link("queries"), "'queries' links were found"
    should.exist rootCollection.link("template"), "'template' link were found"

  it "should follow a link from the root", (done)->
    rootCollection.link("queries").follow (error, queriesCol)->
      throw error if error
      should.exist queriesCol, "No collection was returned"
      should.exist queriesCol.query("all"), "'all' query is not defined"
      should.exist queriesCol.query("open"), "'open' query is not defined"
      should.exist queriesCol.query("closed"), "'closed' query is not defined"
      should.exist queriesCol.query("date-range"), "'date-range' query is not defined"
      done()

  it "should submit a query", (done)->
    query = rootCollection.query("date-range")
    query.set "date-start", "2011-12-01"
    query.submit (error, filteredCol)->
      throw error if error
      filteredCol.items.length.should.equal 2
      done()

  it "should return some items", (done)->
    rootCollection.query("all").submit (error, itemsCol)->
      throw error if error
      should.exist itemsCol, "No collection was returned"
      should.exist itemsCol.items, "No items were returned in the collection"
      itemsCol.items.length.should.equal db._data.length
      for i in [0..db._data.length-1]
        should.exist itemsCol.items[i], "Item was not return when requested by index: #{i}"
        item = itemsCol.items[i]
        should.exist item.datum("description"), "Item should have a description"
        should.exist item.datum("completed"), "Item should have a completed property"
        should.exist item.datum("dateDue"), "Item should have a dateDue"
        item.get("description").should.equal db._data[i].description
        item.get("completed").should.equal db._data[i].completed
        item.get("dateDue").should.equal db._data[i].dateDue
      done()

  it "should be able to add an item", (done)->
    rootCollection.link("template").follow (error, templateCol)->
      throw error if error
      template = templateCol.template()
      template.set "description", "This is a test"
      template.set "dueDate", "2012-10-06"
      template.set "completed", false

      expectedLength = db._data.length+1

      template.submit (error)->
        throw error if error
        db._data.length.should.equal expectedLength

        rootCollection.query("all").submit (error, itemsCol)->
          itemsCol.items.length.should.equal expectedLength
          done()

  # describe "Templates", ->

  #   it "should add an item", (done)->
  #     rootCollection.link("template").follow (error, templateCol)->
  #       throw error if error
  #       template = templateCol.addItem()
  #       template.set "description", "This is a test"
  #       template.set "dueDate", "2012-10-06"
  #       template.set "completed", false

  #       expectedLength = db._data.length+1

  #       template.submit (error, items)->
  #         throw error if error
  #         items.items().length.should.equal expectedLength
  #         done()

  #   it "should edit an item", (done)->
  #     rootCollection.query("all").submit (error, items)->
  #       throw error if error
  #       items.item(0).load (error, itemCol)->
  #         throw error if error

  #         template = itemCol.item(0).edit()
  #         template.set "description", "Testing123"

  #         template.submit (error, itemColNew)->
  #           itemColNew.item(0).datum("description").should.equal "Testing123"
  #           done()

  #   it "should follow an item's link"
  #   it "should read [template collection](https://github.com/mamund/collection-json/blob/master/extensions/templates.md)"
  #   it "should submit [template collection](https://github.com/mamund/collection-json/blob/master/extensions/templates.md)"
  #   it "should [validate template input](https://github.com/mamund/collection-json/blob/master/extensions/template-validation.md)"
  # describe "Errors", ->
  #   it "should return an error when present"
  #   it "should return a [collection of errors](https://github.com/mamund/collection-json/blob/master/extensions/errors.md)"

