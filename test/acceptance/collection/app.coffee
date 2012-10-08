# 2001-05-25 (mca) : collection+json 
# Designing Hypermedia APIs by Mike Amundsen (2011) 

###
Module dependencies.
###

# for express
express = require("express")
app = module.exports = express()

db = require "./fixtures/db"

# global data
contentType = "application/json"
module.exports.host = host = "http://localhost:3000"
module.exports.site = site = "#{host}/collection/tasks"

# Configuration
app.configure ->
  @set "views", __dirname + "/views"
  @set "view engine", "cscj"
  # @use express.bodyParser()

  @use (req, res, next)->
    if req.get("content-type") is "application/vnd.collection+json"
      buf = ""
      req.on "data", (chunk)->
        buf += chunk
      req.on "end", ()->
        try
          req.body = JSON.parse buf
          next()
        catch e
          e.body = buf
          e.status = 400
          next e
    else
      next()

  @use express.methodOverride()
  @use @router

  # Make a layout helper
  @locals.queries = (collection)->
    collection.query ->
      @rel "all"
      @href "#{site}/;all"
      @prompt "All tasks"
    collection.query ->
      @rel "open"
      @href "#{site}/;open"
      @prompt "Open tasks"
    collection.query ->
      @rel "closed"
      @href "#{site}/;closed"
      @prompt "Closed tasks"
    collection.query ->
      @rel "date-range"
      @href "#{site}/;date-range"
      @prompt "Date Range"
      @datum name: "date-start", value: "", prompt: "Start Date"
      @datum name: "date-stop", value: "", prompt: "Stop Date"

  @locals.template = (collection)->
    collection.template ->
      @datum name: "description", value: "", prompt: "Description"
      @datum name: "dateDue", value: "", prompt: "Date Due (yyyy-mm-dd)"
      @datum name: "completed", value: "", prompt: "Completed (true/false)?"

  @locals.links = (collection)->
    collection.link rel: "author", href: "mailto:mamund@yahoo.com", prompt: "Author"
    collection.link rel: "profile", href: "http://amundsen.com/media-types/collection/profiles/tasks/", prompt: "Profile"
    collection.link rel: "queries", href: "#{site}/;queries", prompt: "Queries"
    collection.link rel: "template", href: "#{site}/;template", prompt: "Template"

# register custom media type as a JSON format
app.configure "development", ->

  @use (error, req, res, next)->
    console.error error

    status = error.status or 500

    collection = 
      collection:
        version: "1.0"
        href: "#{host}#{req.url}"
        error:
          code: status
          title: error.message
          message: error.stack
        links: []

    res.send status, collection

app.configure "production", ->
  app.use express.errorHandler()

# register custom media type as a JSON format
# express.bodyParser.parse["application/collection+json"] = JSON.parse

##Routes

# handle default task list 
app.get "/collection/tasks", (req, res, next) ->
  view = "/_design/example/_view/due_date"
  db.get view, (err, doc) ->
    return next err if err
    res.set "content-type", contentType
    res.render "tasks",
      site: site
      tasks: doc

# filters
app.get "/collection/tasks/;queries", (req, res) ->
  res.set "content-type", contentType
  res.render "queries",
    site: site

app.get "/collection/tasks/;template", (req, res) ->
  res.set "content-type", contentType
  res.render "template",
    site: site

app.get "/collection/tasks/;all", (req, res, next) ->
  view = "/_design/example/_view/all"
  db.get view, (err, doc) ->
    return next err if err
    res.set "content-type", contentType
    res.render "tasks",
      site: site
      tasks: doc

app.get "/collection/tasks/;open", (req, res, next) ->
  view = "/_design/example/_view/open"
  db.get view, (err, doc) ->
    return next err if err
    res.set "content-type", contentType
    res.render "tasks",
      site: site
      tasks: doc

app.get "/collection/tasks/;closed", (req, res, next) ->
  view = "/_design/example/_view/closed"
  db.get view, (err, doc) ->
    return next err if err
    res.set "content-type", contentType
    res.render "tasks",
      site: site
      tasks: doc

app.get "/collection/tasks/;date-range", (req, res, next) ->
  options =
    startDate: req.query["date-start"]
    endDate: req.query["date-stop"]

  view = "/_design/example/_view/due_date"
  db.get view, options, (err, doc) ->
    return next err if err
    res.set "content-type", contentType
    res.render "tasks",
      site: site
      tasks: doc

# handle single task item
app.get "/collection/tasks/:i", (req, res, next) ->
  view = req.params.i
  db.get view, (err, doc) ->
    return next err if err
    res.set "content-type", contentType
    res.set "etag", doc._rev
    res.render "tasks",
      site: site
      tasks: [doc]

# handle creating a new task 
app.post "/collection/tasks", (req, res, next) ->
  description = undefined
  completed = undefined
  dateDue = undefined

  # get data array
  data = req.body.template.data
  i = 0
  x = data.length

  # pull out values we want
  while i < x
    switch data[i].name
      when "description"
        description = data[i].value
      when "completed"
        completed = data[i].value
      when "dateDue"
        dateDue = data[i].value
    i++

  # build JSON to write
  item = {}
  item.description = description
  item.completed = completed
  item.dateDue = dateDue
  item.dateCreated = today()

  # write to DB
  db.save item, (err, doc) ->
    if err
      err.status = 400
      next err
    else
      res.redirect 303, site

# handle updating an existing task item 
app.put "/collection/tasks/:i", (req, res, next) ->
  idx = (req.params.i or "")
  description = undefined
  completed = undefined
  dateDue = undefined

  # get data array
  data = req.body.template.data
  i = 0
  x = data.length

  # pull out values we want
  while i < x
    switch data[i].name
      when "description"
        description = data[i].value
      when "completed"
        completed = data[i].value
      when "dateDue"
        dateDue = data[i].value
    i++
  # build JSON to write
  item = {}
  item.description = description
  item.completed = completed
  item.dateDue = dateDue
  item.dateCreated = today()
  db.update idx, item, (err, doc) ->
    if err
      err.status = 400
      next err
    else
      # return the same item
      res.redirect 303, "#{site}/collection/tasks/#{idx}"

# handle deleting existing task
app.delete "/collection/tasks/:i", (req, res, next)->
  idx = (req.params.i or "")
  db.remove idx, (err, doc) ->
    if err
      err.status = 400
      next err
    else
      res.status = 204
      res.send()

today = ->
  y = undefined
  m = undefined
  d = undefined
  dt = undefined
  dt = new Date()
  y = dt.getFullYear()
  m = dt.getMonth() + 1
  m = "0" + m  if m.length is 1
  d = dt.getDate()
  d = "0" + d  if d.length is 1
  y + "-" + m + "-" + d

# Only listen on $ node app.js
unless module.parent
  port = 3000
  app.listen port
  console.log "Express server listening on port %d", port

