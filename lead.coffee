# Package Modules
{log} = require "fairmont"
{randomKey} = require "pirate/src/keys"
{storage, transport} = require "./environment"

Publisher = require "pirate/src/channels/composite/pubsub/publisher"

class Lead
  
  constructor: (@test) ->
    @channel = "orca:#{@test.name}"
    
    @announcements = new Publisher
      transport: transport
      name: @channel

    @nodes = []
    
  publish: (content) ->
    @announcements.publish content

  on_reply: (id, handler) ->
    @announcements.on "#{@channel}.#{id}.reply", handler

  remove: (id, handler) ->
    @announcements.bus.remove "#{@channel}.#{id}.reply", handler

  run: ->

    process.on "exit", =>
      @announcements.end()

    @announcements.on "#{@channel}.*.error", (error) =>
      log error

    log "Orca leader running."
    log "Scenario: #{@test.name}"
    log "Description: #{@test.description}"

    storage.collection @test.name, (error, collection) =>
      @collection = collection
      @announce()
    
  isQuorum: ->
    @nodes.length == @test.quorum
    
  announce: ->
    
    id = tid = null
    
    join = (reply) =>
      # first, double-check to make sure we don't already have a quorum
      return if @isQuorum()
      
      # also make sure we don't add the same node twice 
      return if reply.replyTo in @nodes
      
      # we still need more nodes, so add the node that replied
      @nodes.push reply.replyTo
      unless @isQuorum()
        need = @test.quorum - @nodes.length
        log "- #{reply.replyTo} joining, #{@nodes.length} nodes participating, need #{need} more"
      else
        log "- #{reply.replyTo} joining, #{@nodes.length} nodes participating, quorum reached"
        @remove id, join
        clearTimeout tid
        @prepare()
      
    announce = =>
      return if @isQuorum()
      @remove id, join if id?
      id = @publish action: "announce"
      @on_reply id, join
      log "Test #{@test.name} announced, waiting for replies"
      # basically, keep re-broadcasting for late-comers until we get a quorum
      tid = setTimeout announce, 5000 # 5 seconds

    announce()

        
  prepare: ->
    
    id = @publish
      action: "prepare"
      package: @test.package
      options: @test.options
      
    log "Nodes are preparing for test #{@test.name}"

    count = 0
    ready = (reply) =>
      if reply.content
        if reply.replyTo in @nodes
          need = @nodes.length - (++count)
          unless need is 0
            log "- #{reply.replyTo} ready, waiting on #{need} more"
          else
            log "- #{reply.replyTo} ready, all nodes are ready"
            @remove id, ready
            @start()
        else
          log "- stray node replied: #{reply.replyTo}"
      else
        log "- node #{reply.replyTo} opted out"
        process.exit -1
        
    @on_reply id, ready
          
  start: ->
    
    {inspect} = require "util"
    log "Starting test"
    timestamp = Math.round(Date.now() / 1000)
    testId = randomKey(16)
    id = @publish
      testId: testId
      timestamp: timestamp
      action: "start"
      repeat: @test.repeat
      step: @test.step
      timeout: @test.timeout
    
    count = 0; results = []
    finished = (reply) =>
      if reply.replyTo in @nodes
        results.push reply.content
        need = @nodes.length - (++count)
        unless need is 0
          log "- #{reply.replyTo} returned result, waiting on #{need} more"
        else
          log "- #{reply.replyTo} returned result, test complete"

          result_record =
            testId: testId
            timestamp: timestamp
            configuration: @test
            results: results
          log JSON.stringify(result_record)
          @collection.insert result_record, {safe: true}, (error, records) =>
            if error
              log error
            else
              log "Stored result in mongo"

            @remove id, finished
            @announcements.end()
            # TODO: figure out why we don't exit naturally at this point
            process.nextTick -> process.exit 0
    
    @on_reply id, finished
    
module.exports = Lead
