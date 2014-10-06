redis = require "redis"
{async, safely, promise, lift} = require "./async-helpers"
{redis: {port, host, options}} = require "./configuration"

make_client = ->
  promise (resolve, reject) ->
    client = redis.createClient port, host, options
    .on "connect", -> resolve client
    .on "error", -> reject error

publish = async (channel, message) ->
  client = yield make_client()
  _publish = lift client.publish.bind(client)
  yield _publish channel, (JSON.stringify message)

subscribe = async (channel) ->
  client = yield make_client()
  messages = []
  promised = null
  _subscribe = lift client.subscribe.bind(client)
  _unsubscribe = lift client.unsubscribe

  yield _subscribe channel

  client.on "message", (channel, json) ->
    message = JSON.parse json
    if promised?
      promised.resolve(message)
      promised = null
    else
      messages.push message

  next: ->
    if promised?
      promised
    else if messages.length > 0
      messages.shift()
    else
      promise (resolve) ->
        promised = {resolve}

  unsubscribe: async (channel) ->
    yield _unsubscribe
    client.quit()

module.exports = {publish, subscribe}
