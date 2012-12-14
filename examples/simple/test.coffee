request = require "request"

class Test
  
  constructor: (options, callback) ->
    @url = options.url
    callback(null)

  run: (callback) ->
    request @url, (error, response, body) =>
      if error
        callback new Error "Problem with request: #{error}"
      else if response.statusCode != 200
        callback new Error "Unexpected status: #{response.statusCode}"
      else
        callback null

module.exports = Test
