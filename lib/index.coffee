
request = require "request"
http = require "./http"

request.defaults followAllRedirects: true

http._get = (href, options, done)->
  options.url = href
  request options, (error, response, body)->
    done error, body, response?.headers

http._post = (href, options, done)->
  options.url = href
  options.body = JSON.stringify options.body
  options.method = "POST"
  request options, (error, response, body)->
    done error, body, response?.headers

http._put = (href, options, done)->
  options.url = href
  options.body = JSON.stringify options.body
  request.put options, (error, response)->
    done error, response

http._del = (href, options, done)->
  options.url = href
  request.del options, (error, response)->
    done error, response

module.exports = require "./client"
