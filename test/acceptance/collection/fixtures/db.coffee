
_ = require "underscore"

_data = [
  _id : "task1"
  description : "This is my first task."
  completed : false
  dateCreated : "2011-06-01"
  dateDue : "2011-12-31"
,
  _id : "task2",
  description : "This is my second task.",
  completed : true,
  dateCreated : "2011-06-01",
  dateDue : "2011-12-29"
,
  _id : "task3",
  description : "This is my third task.",
  completed : false,
  dateCreated : "2011-06-01",
  dateDue : "2011-11-30"
]

data = _.clone _data

module.exports =
  get: (view, options, done)->
    if typeof options is "function"
      done = options
      options = {}
    
    switch view
      when "/_design/example/_view/all"
        done null, data
      when "/_design/example/_view/open"
        done null, _.filter data, (task)-> task.description? and task.dateCreated? and task.dateDue? and task.completed is false
      when "/_design/example/_view/closed"
        done null, _.filter data, (task)-> task.description? and task.dateCreated? and task.dateDue? and task.completed is true
      when "/_design/example/_view/due_date"
        done null, _.filter data, (task)->
          due = new Date task.dateDue
          start = due > if options.startDate then new Date options.startDate else 0
          end = due < if options.endDate then new Date options.endDate else 9999999999999999
          start and end
      else
        # it's an item
        done null, _.find data, (task)-> task._id is view
  save: (doc, done)->
    doc._id = "task#{data.length+1}"
    data.push doc
    done null, doc
  update: (id, doc, done)->
    item = _.find data, (item)-> item._id is id
    return done new Error("Item not found") if not item
    for key, value of doc
      item[key] = value
    done null, item
  remove: (id, done)->
    removed = false
    data = _.filter data, (item)->
      keep = item._id isnt id
      removed = not removed and not keep
      keep
    return done new Error("Item #{id} not found") if not removed
    done null

  reset: ()->
    data = _.clone _data

  _data: data
