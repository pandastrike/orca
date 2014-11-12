{async, promise} = require "./async-helpers"

module.exports =

  prepare: (@logger) ->
    @logger.debug "Preparing test..."

  run: ->
    @logger.debug "Running test..."

    promise (resolve, reject) =>
      to = "Pandas Are Awesome.";  from = ""

      config =
        host: 'target.orca'
        port: 1337

      client = ((require "net").createConnection config)

      .on "connect", =>
        @logger.debug "Sending message: #{to}"
        client.write to
        client.end()

      .on "data", (buffer) => from += buffer.toString()
      .on "end", =>
        @logger.debug "Received message: #{from}"
        if to == from then resolve(from) else reject()
