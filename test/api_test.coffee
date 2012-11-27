helpers = require("./helpers")
Testify = require "testify"
assert = require("assert")

helpers.discover_api (client) ->

  Testify.test "orca test results", (context) ->

    client.resources.tests.last
      on:
        response: (response) ->
          context.fail "Unexpected response status: #{response.status}"
        200: (response, test) ->
          context.test "200 response status", -> context.pass()

          console.log test
          test.summary
            on:
              response: (response) ->
                console.log "UNEXPECTED", response
              200: (response, data) ->
                console.log JSON.stringify(data, null, 2)



