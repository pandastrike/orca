{randomKey} = require "key-forge"
configuration = require "./configuration"
{publish, subscribe} = require "./pub-sub"
{async} = require "./async-helpers"
{timer} = require "./helpers"
logger = (require "log4js").getLogger()
module.exports = async ->

  key = randomKey(8)

  channels =
    leader: "orca.#{key}.leader"
    drones: "orca.#{key}.drones"

  {test, quorum} = configuration

  drones = []
  results = []

  # Send prepare message every second until we have a quorum
  do announce = ->
    timer 1000, async ->
      unless quorum == drones.length
        logger.debug "Announcing test..."
        yield publish "orca.broadcast", {announce: test,  channels}
        announce()

  # Wait for messages until we get a quorum
  logger.debug "Waiting for replies..."
  {next, unsubscribe} = yield subscribe channels.drones
  logger.debug "Subscribed to #{channels.drones}..."
  until quorum == drones.length
    {join} = yield next()
    if join?
      drones.push join
      logger.debug "#{drones.length} drones have joined..."

  # Okay, now we have a quorum, send the start message
  logger.debug "Quorum reached, beginning test..."
  yield publish channels.leader, start: test

  # Now we just wait for results
  until quorum == results.length
    result = yield next()
    if result?
      results.push result
      logger.debug "#{results.length} results in..."

  logger.debug "All the results are in"
  console.log results
  unsubscribe()
