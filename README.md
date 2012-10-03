Collection+JSON Client for JavaScript [![Build Status](https://secure.travis-ci.org/CamShaft/collection-json.js.png)](http://travis-ci.org/CamShaft/collection-json.js)
=====================================

Documentation will be finished once the API is solidified.

Features
--------

* Simple API
* Node.js and Browser compatible
* Query/Template building
* HTTP client
* Built in caching with the ability to add a custom backend (Memory, LocalStorage, Memcache, Redis, Riak, etc)


Example
-------

```js
var cj = require("collection-json");

cj("http://example.com", function(error, collection){
  collection.link('users').follow(function(error, collection){
    console.log(collection.items());

    collection.item(0).link('address').follow(function(error, collection){
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
