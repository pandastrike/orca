{randomKey} = require "key-forge"
configuration = require "./configuration"
{publish, subscribe} = require "./pub-sub"
{async} = require "./async-helpers"
{timer} = require "./helpers"
logger = (require "log4js").getLogger()
module.exports = async ->

  # key = randomKey()

  channels =
    leader: "orca.leader"
    drones: "orca.drones"

  {test, quorum} = configuration

  drones = []
  results = []

  # Send prepare message every second until we have a quorum
  do announce = ->
    timer 1000, async ->
      unless quorum == drones.length
        logger.debug "Announcing test..."
        yield publish channels.leader, announce: test
        announce()

  # Wait for messages until we get a quorum
  logger.debug "Waiting for replies..."
  {next} = yield subscribe channels.drones
  logger.debug "Subscribed to #{channels.drones}..."
  until quorum == drones.length
    {join} = yield next()
    logger.debug "Message received..."
    drones.push join if join?
    logger.debug "#{drones.length} drones have joined..."

  # Okay, now we have a quorum, send the start message
  logger.debug "Quorum reached, beginning test..."
  yield publish channels.leader, start: test

  # Now we just wait for results
  until quorum == results.length
    {result} = yield next()
    results.push message.result if result?
