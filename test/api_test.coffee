helpers = require("./helpers")
Testify = require "testify"
assert = require("assert")
Ascribe = require("ascribe")

helpers.discover_api (client) ->

  Testify.test "orca test results", (context) ->

    client.resources.test_results.last
      on:
        response: (response) ->
          context.fail "Unexpected response status: #{response.status}"
        200: (response, data) ->
          context.test "200 response status", -> context.pass()
          datasets = {}
          for result in data.results
            datasets[result.concurrency] ||= []
            datasets[result.concurrency].push(result.time)

          interleaved = {}
          for concurrency, times of datasets
            array = interleaved[concurrency] = []
            l = times[0].length
            for i in [0..l-1]
              for time in times
                array.push(time[i])

          #console.log JSON.stringify(interleaved, null, 2)
          flattened = []
          for name, data of interleaved
            flattened = flattened.concat(data)
          Ascribe.draw flattened



