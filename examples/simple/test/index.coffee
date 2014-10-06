{async, promise} = require "./async-helpers"

module.exports =

  prepare: (@logger) ->
    @logger.debug "Preparing test..."

  run: ->
    @logger.debug "Running test..."
    promise (resolve, reject) ->
      setTimeout (-> resolve true), 1000
