/**
 * Module dependencies
 */
var http = require("./http")
  , Collection = require("./attributes/collection");

/**
 * Request a CJ resource
 */
module.exports = function(href, options, fn) {
  if(typeof options === "function") {
    fn = options;
    options = {};
  }

  http(options)
    .get(href)
    .end(function(err, res) {
      if(err) return fn(err);

      fn(null, new Collection(res.body));
    });
};
