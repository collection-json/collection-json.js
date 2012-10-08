
http = require "../lib/http"
angular = window.angular
client = require "../lib/client"

cj = angular.module "collection-json"

cj.factory "collection-json", [
  "$http"

  ($http)->
    http._get = (href, options, done)->
      $http.get(href, options)
        .success((data, status, headers, config)->
          done null,
            request:
              href: href
            body: data
            headers: headers
        )
        .error((data, status, headers, config)->
          done status,
            request:
              href: href
            body: data
            headers: headers
        )


    http._post = (href, options, done)->

    http._put = (href, options, done)->

    http._del = (href, options, done)->

    client
]
