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
  return
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
    medians = []
    mins = []
    maxes = []
    errors = []
    timeouts = []

    for step in steps
      console.log step.count
      mins.push [step.count, step.min]
      medians.push [step.count, step.median]
      maxes.push [step.count, step.max]
      errors.push [step.count, step.errors]
      timeouts.push [step.count, step.timeouts]

    $.jqplot id, [maxes, medians, mins, errors, timeouts],
      title: "Action response times (may include more than one request)"
      gridPadding: { right: 20, left: 40 }
      legend:
        show: true
        location: "nw"
      series: [
        {
          color: "#609"
          showLine: true
          label: "max in ms"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#396"
          showLine: true
          label: "median in ms"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#369"
          showLine: true
          label: "min in ms"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#c66"
          showLine: true
          label: "error count"
          markerOptions:
            show: true
            style: "circle"
            size: 7
        },
        {
          color: "#ff9"
          showLine: true
          label: "timeout count"
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
          #label: "ms OR error count"
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
    200: (response, summary) ->

      config = summary.configuration
      #console.log Object.keys(config)
      date = new Date(summary.timestamp * 1000)
      $("#test_identifier").text("#{summary.name}: #{date}")
      details = """
        <div id="test_description"><b>Description</b>: #{config.description}</div>
        <span><b>Clients</b>: #{config.quorum}</span>
        <span><b>Repeat</b>: #{config.repeat}</span>
        <span><b>Step</b>: #{config.step}</span>
        <span><b>Timeout</b>: #{config.timeout} ms</span>
        <span><b>Options</b>: <code>#{JSON.stringify(config.options)}</code></span>
      """

      $("#test_details").html(details)

      $("#summary").html("")
      for step in summary.steps
        delete step.concurrency
      steps = sample_data(summary.steps)
      if summary.steps.length < 10
        draw_pie steps[steps.length-1]
      else
        $("#error_chart").html ""
      plot = draw_series "concurrency_chart", steps

      $("#concurrency_chart").bind "jqplotDataClick", (event, series, point, _data) ->
        step = steps[point]
        $("#summary").html ""
        if summary.steps.length < 10
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
        limit: 32
      on:
        response: (response) ->
          console.log "UNEXPECTED", response
        200: (response, test_list) ->
          ul = $("#test_list")
          for test in test_list
            do (test) =>
              config = test.configuration

              li = $("<li/>")
              d = new Date(test.timestamp * 1000)
              parts = d.toString().split(" ")
              time = parts.slice(1,5).join(" ")
              a = $("<a>#{test.name}: #{time}</a>")
              a.click (event) =>
                event.preventDefault()
                test.summary(summarizer)
              description = $("<span>#{config.description}</span>")

              li.append(a, description)
              ul.append(li)

          if (test = test_list[0])
            test.summary(summarizer)
          else
            $("#test_list").html("No results found")

                  





