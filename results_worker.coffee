{log, abort, reader, callbacks} = require "fairmont"

Worker = require "./worker"

class ResultsWorker extends Worker
  
  constructor: (environment) ->
    super environment, "test_results"
    
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
    criteria =
      name: "si_events"
    @collection.findOne criteria, {sort: {$natural: -1}}, (error, data) =>
      out = @transform(data)
      @event "#{@name}.#{id}.result", out


  # helpers

  transform: (data) ->
    {name, testId, configuration, results} = data
    flattened = []
    for node in results
      for result in node
        flattened.push(result)
    flattened.sort (a, b) ->
      parseInt(a.concurrency) - parseInt(b.concurrency)
    out =
      name: name
      testId: testId
      configuration: configuration
      results: flattened


module.exports = ResultsWorker
