{randomKey} = require "key-forge"
configuration = require "./configuration"
{publish, subscribe} = require "./pub-sub"
{async} = require "./async-helpers"
{timer} = require "./helpers"
logger = (require "log4js").getLogger()


module.exports = async ->

  channels =
    leader: "orca.leader"
    drones: "orca.drones"

  logger.debug "Subscribing to #{channels.leader}"
  {next} = yield subscribe channels.leader

  logger.debug "Awaiting test announcement..."
  {announce} = yield next()

  if announce?
    logger.debug "Test #{announce.name} announced..."
    logger.debug "Publishing join message..."
    yield publish channels.drones, join: true

  {start} = yield subscribe channels.leader

  timer 5000, async -> yield publish channels.leader, result: true
