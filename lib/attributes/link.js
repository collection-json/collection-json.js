/**
 * Module dependencies
 */
var cj = require("../../collection-json");

/**
 * Link
 */
function Link(obj) {
  this.l = obj;
};

Link.prototype.href = function() {
  return this.l.href;
};

Link.prototype.rel = function() {
  return this.l.rel;
};

Link.prototype.prompt = function() {
  return this.l.prompt;
};

Link.prototype.follow = function(options, fn) {
  cj(this.href(), options, fn);
};

/**
 * Expose item
 */
module.exports = Item;
