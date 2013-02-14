# Package Modules
_sh = require "node-system"
{log,readdir} = require "fairmont"


sh = (command) ->
  log command
  _sh command

Subscriber = require "pirate/src/channels/composite/pubsub/subscriber"

class Node
  
  constructor: (@environment, options) ->
    {@name} = options
    @channel = "orca:#{@name}"
    @inProgress = false
    
    @announcements = new Subscriber
      transport: @environment.transport()
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
      
    @announcements.listen()
    log "Orca node running, waiting for announcements on '#{@channel}'"


  announce: (message) ->
    @reply message, true
    
  prepare: (message) ->
    log "Preparing #{@announcements.replyTo} for test #{message.package.name}"
    log "Installing #{message.package.name} ..."
    try
      sh "npm install #{message.package.reference}"
      testClass = require message.package.name
      @test = new testClass message.options, (error) =>
        unless error?
          @reply message, true
        else
          log "Opting out due to error creating test object"
          log error
          @reply message, false
          
    catch error
      log "Opting out due to error installing or leading NPM"
      log error
      @reply message, false
      
  start: (message) ->
    @benchmark message
    
  benchmark: (message) ->
    {testId, timestamp, concurrency, timeout} = message
    log "Running test, concurrency: #{concurrency}"
    timings = []
    count = errors = timeouts = 0

    tests = []
    for j in [1..concurrency]
      do (j) =>
        start = null
      
        expire = ->
          timeouts++
          log "Request timed out."
        
        tid = setTimeout expire, timeout
      
        callback = (error, result) =>
          clearTimeout tid
          if error
            errors++
            log error
          else
            timings.push (Date.now() - start)

          if ++count == concurrency
            result =
              concurrency: concurrency
              time: timings
              errors: errors
              timeouts: timeouts
            @reply message, result

        tests.push =>
          start = Date.now()
          @test.run callback
    test() for test in tests

module.exports = Node
