{HTML} = require "nice"
{read} = require "fairmont"
Client = require "patchboard-client"

configuration = JSON.parse read "/configuration.json"

discover = (callback)
  Client.discover configuration.service.url
    request_error: (e) ->
      throw "Problem during API discovery: #{e}"
    error: (response) ->
      throw "HTTP response error: #{response.status}"
    200: (client) ->
      callback(client)
    response: (response) ->
      throw "Received unexpected response status to API discovery: #{response.status}"

discover (client) ->
  $(document).ready ->
    console.log client.resources
