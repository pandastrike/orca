# Package Modules
{log} = require "fairmont"
_sh = require "node-system"

sh = (command) ->
  log command
  _sh command

Subscriber = require "pirate/src/channels/composite/pubsub/subscriber"

transport = require "./transport"

class Node
  
  constructor: (options) ->
    {@test} = options
    @channel = "orca:#{@test.name}"
    
    @inProgress = false
    
    @announcements = new Subscriber 
      transport: transport
      name: @channel

  reply: (message,content) ->
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

    log "Orca node running, waiting for announcements"

  announce: (message) ->
    @reply message, true
    
  prepare: (message) ->
    log "Installing #{message.package.name} ..."
    try
      sh "npm install #{message.package.reference}"
      @fn = require message.package.name
      @reply message, true
    catch error
      log error
      @reply message, false
      
  start: (message) ->
    {repeat} = message
    log "Starting test"
    results = @benchmark repeat
    log "Test results: #{results}"
    @reply message, results
    @announcements.end()
    
  benchmark: (times) ->
    log "Running test #{times} times"
    for i in [1..times]
      start = Date.now()
      @fn()
      Date.now() - start
  
module.exports = Node