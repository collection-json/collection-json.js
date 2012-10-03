
should = require "should"

cj = require ".."

root = "http://employee.herokuapp.com"

describe "Collection+JSON", ->

  describe "client", ->

    it "should get a root resource", (done)->
      cj root, (error, collection)->
        should.not.exist error
        should.exist collection
        should.exist collection.link
        should.exist collection.link("departments")
        should.exist collection.link("employees")
        done()

    it "should follow a link from the root", (done)->
      cj root, (error, collection)->
        should.not.exist error
        should.exist collection
        collection.link("departments").follow (error, departments)->
          should.not.exist error
          should.exist departments
          should.exist departments.link("next")
          done()

    it "should return some items", (done)->
      cj root, (error, collection)->
        should.not.exist error
        should.exist collection
        collection.link("departments").follow (error, departments)->
          should.not.exist error
          should.exist departments
          should.exist departments.item(0)
          should.exist departments.item(0).datum("dept_no")
          departments.item(0).datum("dept_no").should.equal "d001"
          done()

    it "should edit an item"#, (done)->
      # cj root, (error, collection)->
      #   should.not.exist error
      #   should.exist collection
      #   collection.link("departments").follow (error, departments)->
      #     should.not.exist error
      #     should.exist departments
      #     template = should.exist departments.item(0).edit()
      #     template.set "dept_name", "Marketing and Fun"
      #     template.submit (error, department)->
      #       should.not.exist error
      #       should.exist department
      #       done()

    it "should follow an item's link"
    it "should add a new item"

    it "should submit a query"
    it "should submit a query with uri-templates"
    it "should submit a form"
    it "should validate a form"
