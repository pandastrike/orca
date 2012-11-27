gauss = require "gauss"
{log, abort, reader, callbacks} = require "fairmont"

Worker = require "./worker"

class TestsWorker extends Worker
  
  constructor: (environment) ->
    super environment, "tests"
    
  run: ->
    @environment.collection "results", (error, collection) =>
      if error
        log error
        abort
      else
        @collection = collection
        super
    
  # task handlers

  last: (task) ->
    {id, content} = task
    criteria = {}
    fields = {name:1, testId:1, timestamp:1, configuration:1}
    @collection.findOne criteria, fields, {sort: {$natural: -1}}, (error, data) =>
      if error
        log error
        @event "#{@name}.#{id}.error", error
      else
        @event "#{@name}.#{id}.result", @marshal("test", data)

  marshal: (name, data) ->
    # FIXME: this only works for top level schema props.
    output = {}
    schema = @environment.schema.find(name)
    for name, def of schema.properties
      output[name] = data[name] || null
    output

  list: (task) ->
    {id, content} = task
    criteria = {}
    fields = {name:1, testId:1, timestamp:1, configuration:1}
    options = {sort: {$natural: -1}, limit: 8}
    @collection.find criteria, fields, options, (error, data) =>
      if error
        log error
        @event "#{@name}.#{id}.error", error
      else
        data.toArray (error, array) =>
          if error
            log error
            @event "#{@name}.#{id}.error", error
          else
            test_list = for item in array
              @marshal("test", item)
            @event "#{@name}.#{id}.result", test_list

  results: (task) ->
    {id, content} = task
    criteria = {testId: content.identifier.testId}
    fields = {results:1}
    @collection.findOne criteria, fields, {sort: {$natural: -1}}, (error, data) =>
      if error
        log error
        @event "#{@name}.#{id}.error", error
      else
        @event "#{@name}.#{id}.result", {nodes: data.results}

  summary: (task) ->
    {id, content} = task
    criteria = {testId: content.identifier.testId}
    fields = {results:1}
    @collection.findOne criteria, fields, {sort: {$natural: -1}}, (error, data) =>
      if error
        log error
        @event "#{@name}.#{id}.error", error
      else
        steps = @transform(data.results)
        steps = for step in steps
          @summarize(step)
        @event "#{@name}.#{id}.result", {steps: steps}

  # helpers

  summarize: (step) ->
    vector = step.times.toVector()
    delete step.times
    step.mean = vector.mean()
    step.median = vector.median()
    step.stdev = vector.stdev()
    step.min = vector.min()
    step.max = vector.max()
    step

  transform: (results) ->
    data = {}
    for node, steps of results
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




module.exports = TestsWorker
