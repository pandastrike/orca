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
  $("#error_chart").html ""
  data = [
    ["Successful", step.count],
    ["Errors", step.errors],
    ["Timeouts", step.timeouts]
  ]
  pie = $.jqplot "error_chart", [data],
    title: "Errors for concurrency: #{step.count}"
    seriesColors: ["#396", "#c66", "#ff9"]
    seriesDefaults:
      renderer: $.jqplot.PieRenderer
      rendererOptions:
        showDataLabels: true
        dataLabelNudge: 3
    legend: {show: true, location: "e"}


draw_bar = (id, steps) ->
  $("##{id}").html("")
  ticks = []
  series = []
  for step in steps
    ticks.push step.count
    series.push step.mean

  plot = $.jqplot id, [series],
    title: "Mean response times"
    seriesColors: ["#396"]
    seriesDefaults:
      renderer: $.jqplot.BarRenderer
      rendererOptions:
        fillToZero: true
    axes:
      xaxis:
        label: "Concurrent requests"
        renderer: $.jqplot.CategoryAxisRenderer
        ticks: ticks
      yaxis:
        label: "ms"

summarizer =
  on:
    response: (response) ->
      console.log "UNEXPECTED", response
    200: (response, data) ->
      $("#summary").html("")
      for step in data.steps
        delete step.concurrency
      draw_pie data.steps[data.steps.length-1]
      plot = draw_bar "concurrency_chart", data.steps

      $("#concurrency_chart").bind "jqplotDataClick", (event, series, point, _data) ->
        step = data.steps[point]
        $("#summary").html ""
        draw_pie step
        $("#summary").append """
        <pre>#{JSON.stringify(step, null, 2)}</pre>
        """
                  

discover (client) ->
  $(document).ready ->

    client.resources.tests.list
      query:
        limit: 16
      on:
        response: (response) ->
          console.log "UNEXPECTED", response
        200: (response, test_list) ->
          tests_div = $("#test_list")
          for test in test_list
            do (test) =>
              config = test.configuration

              li = $("<li/>")
              d = new Date(test.timestamp * 1000)
              parts = d.toString().split(" ")
              time = parts.slice(1,5).join(" ")
              a = $("<a>#{time}</a>")
              a.click (event) =>
                $("#test_identifier").text(time)
                $("#details-#{test.testId}").slideToggle(100)
                event.preventDefault()
                test.summary(summarizer)

              name = $("<p>name: #{test.name}</p>")
              console.log Object.keys(config)
              details = $("""
                <ul class="details" id="details-#{test.testId}">
                  <li><b>Description</b>: #{config.description}</li>
                  <li><b>Test clients</b>: #{config.quorum}</li>
                  <li><b>Repeat</b>: #{config.repeat}</li>
                  <li><b>Step</b>: #{config.step}</li>
                </ul>
              """)

              li.append(a, name, details)
              tests_div.append(li)

          if (test = test_list[0])
            test.summary(summarizer)
          else
            $("#test_list").html("No results found")

                  





