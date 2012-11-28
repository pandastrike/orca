{HTML} = require "nice"
{read} = require "fairmont"
Client = require "patchboard-client"

configuration = JSON.parse(read("/configuration.json"))

discover = (callback) ->
  Client.discover configuration.service.url,
    request_error: (e) ->
      console.log e.stack
      throw "Problem during API discovery: #{e}"
    error: (response) ->
      throw "HTTP response error: #{response.status}"
    200: (client) ->
      callback(client)
    response: (response) ->
      throw "Received unexpected response status to API discovery: #{response.status}"


discover (client) ->
  $(document).ready ->

    client.resources.tests.last
      on:
        response: (response) ->
          console.log "UNEXPECTED", response
        200: (response, test) ->
          console.log "name", test.name
          console.log "timestamp", test.timestamp
          test.summary
            on:
              response: (response) ->
                console.log "UNEXPECTED", response
              200: (response, data) ->
                draw_pie = (step) ->
                  pdata = [
                    ["Successful", step.count],
                    ["Errors", step.errors],
                    ["Timeouts", step.timeouts]
                  ]
                  pie = $.jqplot "error_chart", [pdata],
                    title: "Error rates for concurrency: #{step.concurrency}"
                    seriesDefaults:
                      renderer: $.jqplot.PieRenderer
                      rendererOptions:
                        showDataLabels: true
                        dataLabelNudge: 8
                    legend: {show: true, location: "n"}

                draw_pie data.steps[data.steps.length-1]

                ticks = []
                series = []
                for step in data.steps
                  ticks.push step.concurrency
                  series.push step.mean

                plot = $.jqplot "concurrency_chart", [series],
                  title: "Mean response times"
                  seriesDefaults:
                    renderer: $.jqplot.BarRenderer
                    rendererOptions: {fillToZero: true}
                  axes:
                    xaxis:
                      label: "Concurrent requests"
                      renderer: $.jqplot.CategoryAxisRenderer
                      ticks: ticks
                    yaxis:
                      label: "ms"
                $("#concurrency_chart").bind "jqplotDataClick", (event, series, point, _data) ->
                  $("#error_chart").html ""
                  draw_pie data.steps[point]





