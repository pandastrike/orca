{log, abort, reader, callbacks} = require "fairmont"

{compute_steps} = require "./results"

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
    @collection.findOne criteria, fields, {sort: {timestamp: -1}}, (error, data) =>
      if error
        log error
        @event "#{@name}.#{id}.error", error
      else
        @event "#{@name}.#{id}.result", @marshal("test", data)

  list: (task) ->
    {id, content} = task
    limit = content.query?.limit || 8

    criteria = {}
    fields = {name:1, testId:1, timestamp:1, configuration:1}
    options = {sort: {timestamp: -1}, limit: limit}
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
    fields = {results: 1, steps: 1, timestamp: 1}
    fields = {}
    @collection.findOne criteria, fields, {sort: {$natural: -1}}, (error, data) =>
      if error
        log error
        @event "#{@name}.#{id}.error", error
      else
        if !data.steps
          data.steps = compute_steps(data.results)
          @collection.update criteria, {$set: {steps: data.steps}}, (error, result) =>
            if error
              console.error error
            else
              console.log "Saved computed steps to test:", content.identifier.testId
        @event "#{@name}.#{id}.result", @marshal("test_summary", data)

  # helpers


  marshal: (name, data) ->
    # FIXME: this only works for top level schema props.
    output = {}
    schema = @environment.schema().find(name)
    for name, def of schema.properties
      output[name] = data[name] || null
    output





module.exports = TestsWorker
