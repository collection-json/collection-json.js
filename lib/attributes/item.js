/**
 * Module dependencies
 */


/**
 * Item
 *
 * Item object for a collection-json response
 */
function Item(obj) {
  this.i = obj;
};

Item.prototype.href = function() {
  return this.i.href;
};

Item.prototype.datum = function(key) {
  
};

/**
 * Expose item
 */
module.exports = Item;
