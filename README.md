Collection+JSON Client for JavaScript
=====================================

Documentation will be finished once the API is solidified.

Example
-------

```js
var cj = require("collection-json");

cj("http://example.com", function(error, collection){
  collection.links.follow('users', function(error, collection){
    console.log(collection.items());

    collection.items.last.links.follow('address', function(error, collection){
      var template = collection.template();
      template.set('street', '123 Fake Street');
      template.submit(function(error, collection){

        if (!error)
          console.log("SUCCESS!!!");

      });
    });
  });
});
```
