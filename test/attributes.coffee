
should = require "should"

cj = require ".."

describe "Attributes", ->

  describe "[Original](http://amundsen.com/media-types/collection/)", ->

    describe "[collection](http://amundsen.com/media-types/collection/format/#objects-collection)", ->
      it "should have a version"
      it "should have an href"
      it "should throw an exception with a bad version number"
      it "should throw an exception with a malformed collection"

    describe "[error](http://amundsen.com/media-types/collection/format/#objects-error)", ->
      it "should have an error"

    describe "[template](http://amundsen.com/media-types/collection/format/#objects-template)", ->
      it "should iterate properties template"
      it "should be able to set values"
      it "should return a datum given a name"

    describe "[items](http://amundsen.com/media-types/collection/format/#arrays-items)", ->
      it "should iterate items"
      it "should get a value"
        
    describe "[queries](http://amundsen.com/media-types/collection/format/#arrays-queries)", ->

      it "should iterate queries"
      it "should be able to set values"
      it "should get a query by rel"

    describe "[links](http://amundsen.com/media-types/collection/format/#arrays-links)", ->
      it "should get iterate the links"
      it "should get a link by rel"

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
