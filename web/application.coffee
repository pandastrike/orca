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


draw_pie = (step) ->
  data = [
    ["Successful", step.count],
    ["Errors", step.errors],
    ["Timeouts", step.timeouts]
  ]
  pie = $.jqplot "error_chart", [data],
    title: "Error rates for concurrency: #{step.concurrency}"
    seriesDefaults:
      renderer: $.jqplot.PieRenderer
      rendererOptions:
        showDataLabels: true
        dataLabelNudge: 8
    legend: {show: true, location: "e"}


draw_bar = (id, steps) ->
  ticks = []
  series = []
  for step in steps
    ticks.push step.count
    series.push step.mean

  plot = $.jqplot id, [series],
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


discover (client) ->
  $(document).ready ->

    client.resources.tests.last
      on:
        response: (response) ->
          console.log "UNEXPECTED", response
        200: (response, test) ->
          test.summary
            on:
              response: (response) ->
                console.log "UNEXPECTED", response
              200: (response, data) ->
                draw_pie data.steps[data.steps.length-1]
                plot = draw_bar "concurrency_chart", data.steps
                $("#concurrency_chart").bind "jqplotDataClick", (event, series, point, _data) ->
                  step = data.steps[point]
                  $("#error_chart").html ""
                  $("#summary").html ""
                  draw_pie step
                  $("#summary").append """
                  <pre>#{JSON.stringify(step, null, 2)}</pre>
                  """
                  





