
http = require "../lib/http"
angular = window.angular
client = require "../lib/client"

cj = angular.module "collection-json", []

cj.factory "collection-json", [
  "$http"

  ($http)->
    http._get = (href, options, done)->
      # Rename things for angular
      options.params = options.qs
      $http.get(href, options)
        .success((data, status, headers, config)->
          done null, data, headers
        )
        .error((data, status, headers, config)->
          error = null
          if status is 0
            error = new Error
            error.code = 0
            error.title = "Could not connect to the specified host"
            error.message = "Make sure the specified host exists and is working properly"

          done error, data, headers
        )


    http._post = (href, options, done)->

    http._put = (href, options, done)->

    http._del = (href, options, done)->

    client
]
