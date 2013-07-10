gauss = require "gauss"

exports.compute_steps = (results) ->
  steps = transform(results)
  steps = for step in steps
    summarize(step)


summarize = (step) ->
  vector = step.times.toVector()
  count = step.times.length
  delete step.times
  step.count = count
  step.mean = vector.mean()
  step.median = vector.median()
  step.stdev = vector.stdev()
  step.min = vector.min()
  step.max = vector.max()
  step

transform = (results) ->
  data = {}
  for node_id, steps of results
    for result in steps
      array = (data[result.concurrency] ||= [])
      array.push(result)

  merged = {}
  for concurrency, result_list of data
    step = merged[concurrency] = {concurrency: concurrency}
    step.errors = step.timeouts = 0
    step.times = []
    for result in result_list
      step.errors = step.errors + result.errors
      step.timeouts = step.timeouts + result.timeouts

    num_times = result_list[0].time.length
    for i in [0..num_times-1]
      for result in result_list
        step.times.push result.time[i]

  concurrencies = Object.keys(merged).sort (a, b) ->
    parseInt(a) - parseInt(b)
  out = for key in concurrencies
    merged[key]
