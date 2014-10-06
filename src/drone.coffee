{join} = require "path"
{randomKey} = require "key-forge"
configuration = require "./configuration"
{publish, subscribe} = require "./pub-sub"
{async, lift, call} = require "./async-helpers"
{timer} = require "./helpers"
logger = (require "log4js").getLogger()

{exec} = require "shelljs"
abort = (message) ->
  console.error message
  process.abort -1

module.exports = async ->

  logger.debug "Subscribing to orca.broadcast"
  {next, unsubscribe} = yield subscribe "orca.broadcast"

  logger.debug "Awaiting test announcement..."
  {announce, channels} = yield next()
  if announce? && channels?
    logger.debug "Test #{announce.name} announced..."
  yield unsubscribe()

  {next, unsubscribe} = yield subscribe channels.leader

  logger.debug "Installing test package..."

  path = join configuration.path, announce.package
  npm = yield call (npm = require "npm") -> yield do (lift npm.load)
  yield ((lift npm.commands.install) [path])
  _package = require announce.package

  logger.debug "Publishing join message..."
  yield publish channels.drones, join: true

  {start} = yield next() until start?

  logger.debug "Beginning test..."
  _package.prepare(logger)

  result = yield _package.run()
  logger.debug "Test complete sending results..."
  yield publish channels.drones, result: true
  yield unsubscribe()
