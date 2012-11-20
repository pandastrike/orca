# Package Modules
_sh = require "node-system"

{storage, transport} = require "./environment"

sh = (command) ->
  log command
  _sh command

Subscriber = require "pirate/src/channels/composite/pubsub/subscriber"

class Node
  
  constructor: (options) ->
    {@name} = options
    @channel = "orca:#{@name}"
    @inProgress = false
    
    @announcements = new Subscriber
      transport: transport
      name: @channel

  reply: (message, content) ->
    @announcements.event "#{@channel}.#{message.id}.reply", content

  run: ->
    
    process.on "exit", =>
      @announcements.end()
      
    @announcements.on "#{@channel}.*.message", (message) =>
      if @[message.action]?
        @[message.action] message
      else
        log new Error "Invalid task for '#{name}': #{task.action}"
        
    @announcements.on "#{@channel}.*.error", (error) =>
      log error
      
    storage.collection @name, (error, result) =>
      @collection = result
      @announcements.listen()
      log "Orca node running, waiting for announcements on '#{@channel}'"


  announce: (message) ->
    @reply message, true
    
  prepare: (message) ->
    log "Installing #{message.package.name} ..."
    try
      sh "npm install #{message.package.reference}"
      testClass = require message.package.name
      @test = new testClass message.options, (error) =>
        unless error?
          @reply message, true
        else
          log error
          @reply message, false
          
    catch error
      log error
      @reply message, false
      
  start: (message) ->
    #{repeat, concurrency} = message
    log "Starting test"
    @benchmark message
    
  # TODO: this logic might be simpler with fibers
  benchmark: (message) ->
    {testId, timestamp, repeat, step, timeout} = message
    log "Running test #{repeat} times, stepping by #{step}"
    results = []
    runStep = (i) =>
        concurrency = step * i
        timings = []
        count = errors = timeouts = 0

        log "Concurrency level: #{concurrency}"

        tests = for j in [1..concurrency]

          do =>
            start = null
            expired = false
          
            expire = ->
              expired = true
              callback new Error "Request timed out"
            
            tid = setTimeout expire, timeout
          
            callback = (error, result) =>

              unless error? or expired
                timings.push (Date.now() - start)

              clearTimeout tid unless expired

              if error?
                errors++
                log error

              if ++count == concurrency
                results.push
                  testId: testId
                  timestamp: timestamp
                  concurrency: concurrency
                  time: timings
                  errors: errors
                  timeouts: timeouts

                if results.length == repeat
                  @store_results results, (error, references) =>
                    if error
                      @reply message, false
                    else
                      @reply message, {references: references}
                  ## shuts down transport and allows this node to exit
                  #@announcements.end()
                else
                  runStep ++i

            =>
              start = Date.now()
              @test.run callback

        test() for test in tests
    
    runStep 1
            
  store_results: (results, callback) ->
    @collection.insert results, {safe: true}, (error, records) =>
      if error
        callback(error)
      else
        references = records.map (record) ->
          record._id.toHexString()
        callback(null, references)

module.exports = Node
