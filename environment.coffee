{optimistic, callbacks} = require "fairmont"
Transport = require "pirate/src/transports/redis"
Patchboard = require("patchboard-server")

api =
  schema: require("./api/schema")
  resources: require("./api/resources")
  paths: require("./api/paths")



module.exports = class Environment

  constructor: (@configuration) ->
    api.service_url = @configuration.api.service_url
    @service = new Patchboard.Service(api)
    @schema = @service.schema_manager
    @database_name = @configuration.mongo.database || "orca"

  database: (name) ->
    options = @configuration.mongo
    mongo = require "mongodb"
    @server ||= new mongo.Server(options.host, options.port)
    new mongo.Db name, @server, {safe: true}

  collection: (name, callback) ->
    callback = optimistic callback
    @database(@database_name).open callbacks.fatalError (db) ->
      db.collection name, callbacks.fatalError (collection) ->
        callback collection

  transport: ->
    new Transport
      host: @configuration.redis.host
      port: @configuration.redis.port

