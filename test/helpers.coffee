Client = require("patchboard-client")

exports.discover_api = (callback) ->

  Client.discover "http://localhost:1339/",
    request_error: (e) ->
      throw "Problem during API discovery: #{e}"
    error: (response) ->
      throw "HTTP response error: #{response.status}"
    200: (client) ->
      callback(client)
    response: (response) ->
      throw "Received unexpected response status to API discovery: #{response.status}"


