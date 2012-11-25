{optimistic, callbacks} = require "fairmont"
Transport = require "pirate/src/transports/redis"

module.exports = class Environment

  constructor: (@configuration) ->

  database: (name) ->
    options = @configuration.mongo
    mongo = require "mongodb"
    @server ||= new mongo.Server(options.host, options.port)
    new mongo.Db name, @server, {safe: true}

  collection: (name, callback) ->
    callback = optimistic callback
    @database("orca").open callbacks.fatalError (db) ->
      db.collection name, callbacks.fatalError (collection) ->
        callback collection

  transport: ->
    new Transport
      host: @configuration.redis.host
      port: @configuration.redis.port

