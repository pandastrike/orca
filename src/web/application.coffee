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
    title: "Errors for concurrency level: #{step.count}"
    seriesColors: ["#396", "#c66", "#ff9"]
    seriesDefaults:
      renderer: $.jqplot.PieRenderer
      rendererOptions:
        #diameter: 50
        showDataLabels: true
        dataLabelNudge: 3
    legend:
      show: true
      location: "n"


sample_data = (steps) ->
  if steps.size < 10
    steps
  else
    out = []
    interval = Math.ceil(steps.length / 20)
    for step, i in steps
      if i % interval == 0
        out.push(step)
    out


draw_bars = (id, steps) ->
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

draw_lines = (id, steps) ->
  $("##{id}").html("")

  if steps.length >= 10
    means = []
    mins = []
    maxes = []
    errors = []
    timeouts = []

    for step in steps
      means.push [step.count, step.mean]
      mins.push [step.count, step.min]
      maxes.push [step.count, step.max]
      errors.push [step.count, step.errors]
      timeouts.push [step.count, step.timeouts]

    $.jqplot id, [maxes, means, errors, timeouts],
      title: "Mean response times"
      legend:
        show: true
        location: "nw"
      series: [
        {
          color: "#609"
          showLine: true
          label: "max"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#396"
          showLine: true
          label: "mean"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#c66"
          showLine: true
          label: "errors"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#ff9"
          showLine: true
          label: "timeouts"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
      ]
      axes:
        xaxis:
          label: "Concurrent requests"
          min: steps[0].count
          max: steps[steps.length-1].count
          tickOptions:
            formatString: "%i"
        yaxis:
          label: "ms"
          min: 0

draw_series = (id, steps) ->
  if steps.length >= 10
    draw_lines(id, steps)
  else
    draw_bars(id, steps)

summarizer =
  on:
    response: (response) ->
      console.log "UNEXPECTED", response
    200: (response, data) ->
      $("#summary").html("")
      for step in data.steps
        delete step.concurrency
      steps = sample_data(data.steps)
      if data.steps.length < 10
        draw_pie steps[steps.length-1]
      else
        $("#error_chart").html ""
      plot = draw_series "concurrency_chart", steps

      $("#concurrency_chart").bind "jqplotDataClick", (event, series, point, _data) ->
        step = steps[point]
        $("#summary").html ""
        if data.steps.length < 10
          draw_pie step
        else
          $("#error_chart").html ""
          
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

                  





