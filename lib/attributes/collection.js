/**
 * Module dependencies
 */
var http = require("../http")
  , each = require("each")
  , find = require("find")
  , Link = require("./link")
  , Item = require("./item")
  , Query = require("./query")
  , Template = require("./template");

/**
 * Collection
 *
 * Root object for a collection-json response
 */
function Collection(obj) {
  // Verify it is the version we understand
  if(!obj.collection || obj.collection.version !== "1.0") {
    throw new Error("Collection does not conform to Collection+JSON 1.0 Spec");
  }

  this.c = obj.collection;
};

Collection.prototype.href = function() {
  return this.c.href;
};

Collection.prototype.version = function() {
  return this.c.version;
};

Collection.prototype.links = function() {
  if(this._links) return this._links;

  var links = [];

  each(this.c.links, function(link) {
    links.push(new Link(link));
  });

  //Cache the links
  this._links = links;

  return links;
};

Collection.prototype.link = function(rel) {
  return find(this.links(), function(link) {
    return link.rel() === rel;
  });
};

Collection.prototype.items = function() {
  if(this._items) return this._items;

  var items = [];

  each(this.c.items, function(item) {
    items.push(new Item(item));
  });

  //Cache the items
  this._items = items;

  return items;
};

Collection.prototype.item = function(href) {
  return find(this.items(), function(item) {
    return item.href() === href;
  });
};

Collection.prototype.queries = function() {
  if(this._queries) return this._queries;

  var queries = [];

  each(this.c.queries, function(query) {
    queries.push(new Query(query));
  });

  //Cache the queries
  this._queries = queries;

  return queries;
};

Collection.prototype.query = function(rel) {
  return find(this.queries(), function(query) {
    return query.rel() === rel;
  });
};

// TODO support multiple templates:
// https://github.com/mamund/collection-json/blob/master/extensions/templates.md
Collection.prototype.template = function(name) {
  return new Template(this.c.template, this.href());
};

/**
 * Expose collection
 */
module.exports = Collection;
