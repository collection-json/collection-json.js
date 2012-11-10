
http = require "../lib/http"

http.get = (href, options={}, done=()->)->
  $.get(href, options)
  .success((data, textStatus, jqXHR)->
    done data, textStatus, jqXHR
  )
  .error((data, textStatus, jqXHR)->
    done data, textStatus, jqXHR
  )
  .complete((data, textStatus, jqXHR)->
    done data, textStatus, jqXHR
  )

# TODO
# http.post = (href, options={}, done=()->)->

# http.put = (href, options={}, done=()->)->

# http.del = (href, options={}, done=()->)->

window.CollectionJSON = require "../lib/client"
window.CollectionJSON.http = http
