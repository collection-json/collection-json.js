
should = require "should"
fs = require "fs"
_ = require "underscore"

cj = require ".."

describe "Attributes", ->

  describe "[Original](http://amundsen.com/media-types/collection/)", ->

    collection = null
    data = null

    before ->
      data = require "./fixtures/original"

    beforeEach (done)->
      cj.parse data, (error, _collection)->
        throw error if error
        collection = _collection
        done()

    describe "[collection](http://amundsen.com/media-types/collection/format/#objects-collection)", ->
      it "should have a version", ->
        collection.version.should.equal data.collection.version
      it "should have an href", ->
        collection.href.should.equal data.collection.href
      it "should throw an exception with a bad version number", ->
        cj.parse {collection: version: "1.1"}, (error, col)->
          should.exist error, "No error was returned"
      it "should throw an exception with a malformed collection", ->
        cj.parse {version: "1.1"}, (error, col)->
          should.exist error, "No error was returned"

    describe "[error](http://amundsen.com/media-types/collection/format/#objects-error)", ->
      it "should have an error", ->
        errorData = require("./fixtures/error")
        cj.parse errorData, (error, errorCol)->
          should.exist error, "An error was not returned"
          should.exist errorCol, "The collection with the error was not returned"

          error.title.should.equal errorData.collection.error.title
          error.code.should.equal errorData.collection.error.code
          error.message.should.equal errorData.collection.error.message

          errorCol.error.title.should.equal errorData.collection.error.title
          errorCol.error.code.should.equal errorData.collection.error.code
          errorCol.error.message.should.equal errorData.collection.error.message

    describe "[template](http://amundsen.com/media-types/collection/format/#objects-template)", ->
      it "should iterate properties template", ->
        template = collection.template()
        for key, value of template.form
          orig = _.find data.collection.template.data, (datum)-> datum.name is key
          key.should.equal orig.name
          value.should.equal orig.value
          template.promptFor(key).should.equal orig.prompt

      it "should be able to set values", ->
        newItem = collection.template()
        name = "Joe Test"
        email = "test@test.com"
        blog = "joe.blogger.com"
        avatar = "http://www.gravatar.com/avatar/dafd213c94afdd64f9dc4fa92f9710ea?s=512"

        newItem.set "full-name", name
        newItem.set "email", email
        newItem.set "blog", blog
        newItem.set "avatar", avatar

        newItem.get("full-name").should.equal name
        newItem.get("email").should.equal email
        newItem.get("blog").should.equal blog
        newItem.get("avatar").should.equal avatar

      it "should return a datum given a name", ->
        newItem = collection.template()
        fullName = newItem.datum("full-name")
        fullName.name.should.equal "full-name"
        fullName.prompt.should.equal "Full Name"
        fullName.value.should.equal "Joe"

    describe "[items](http://amundsen.com/media-types/collection/format/#arrays-items)", ->
      it "should iterate items", ->
        for idx, item of collection.items
          orig = data.collection.items[idx]
          item.href.should.equal orig.href

      it "should get a value", ->
        for idx, item of collection.items
          orig = data.collection.items[idx]
          for datum in orig.data
            itemDatum = item.get(datum.name)
            should.exist itemDatum, "Item does not have #{datum.name}"
            itemDatum.should.equal datum.value
        
    describe "[queries](http://amundsen.com/media-types/collection/format/#arrays-queries)", ->

      it "should iterate queries", ->
        for query in collection.queries
          orig = _.find data.collection.queries, (_query)-> _query.rel is query.rel
          query.href.should.equal orig.href
          query.rel.should.equal orig.rel
          query.prompt.should.equal orig.prompt

      it "should be able to set values", ->
        searchQuery = collection.query "search"

        searchQuery.set "search", "Testing"

        searchQuery.get("search").should.equal "Testing"

      it "should get a query by rel", ->
        for orig in data.collection.queries
          searchQuery = collection.query orig.rel
          searchQuery.href.should.equal orig.href
          searchQuery.rel.should.equal orig.rel
          searchQuery.prompt.should.equal orig.prompt

    describe "[links](http://amundsen.com/media-types/collection/format/#arrays-links)", ->
      it "should get iterate the links", ->
        for link in collection.links
          orig = _.find data.collection.links, (_link)-> _link.rel is link.rel
          link.href.should.equal orig.href
          link.rel.should.equal orig.rel
          link.prompt.should.equal orig.prompt

      it "should get a link by rel", ->
        for orig in data.collection.links
          link = collection.link(orig.rel)
          link.href.should.equal orig.href
          link.rel.should.equal orig.rel
          link.prompt.should.equal orig.prompt

  describe "[Extensions](https://github.com/mamund/collection-json/tree/master/extensions)", ->

    describe "[errors](https://github.com/mamund/collection-json/blob/master/extensions/errors.md)", ->
      it "need tests"
    describe "[inline](https://github.com/mamund/collection-json/blob/master/extensions/inline.md)", ->
      it "need tests"
    describe "[model](https://github.com/mamund/collection-json/blob/master/extensions/model.md)", ->
      it "need tests"
    describe "[template-validation](https://github.com/mamund/collection-json/blob/master/extensions/template-validation.md)", ->
      it "need tests"
    describe "[templates](https://github.com/mamund/collection-json/blob/master/extensions/templates.md)", ->
      it "need tests"
    describe "[uri-templates](https://github.com/mamund/collection-json/blob/master/extensions/uri-templates.md)", ->
      it "need tests"
    describe "[value-types](https://github.com/mamund/collection-json/blob/master/extensions/value-types.md)", ->
      it "need tests"
