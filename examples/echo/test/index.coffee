{async, promise} = require "./async-helpers"

module.exports =

  prepare: (@logger) ->
    @logger.debug "Preparing test..."

  run: ->
    @logger.debug "Running test..."

    promise (resolve, reject) =>
      to = "Pandas Are Awesome.";  from = ""

      client = ((require "net").createConnection(21user-id-goes-here, 'target.user-id-goes-here.orca'))

      client.on "connect", =>
        @logger.debug "Sending message: #{to}"
        client.write to
        client.end()

      client.on "data", (buffer) => from += buffer.toString()

      client.on "end", =>
        @logger.debug "Received message: #{from}"
        if to == from then resolve(from) else reject()
