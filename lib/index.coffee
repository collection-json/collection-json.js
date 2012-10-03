
request = require "request"
http = require "./http"

http._get = (href, options, done)->
  options.url = href
  request options, (error, response)->
    done error, response

http._post = (href, options, done)->
  options.url = href
  request.post options, (error, response)->
    done error, response

http._put = (href, options, done)->
  options.url = href
  request.put options, (error, response)->
    done error, response

http._del = (href, options, done)->
  options.url = href
  request.del options, (error, response)->
    done error, response

module.exports = require "./client"
